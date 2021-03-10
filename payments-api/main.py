#!/usr/bin/e nv python

import os
import sys
import json
import pika
import uuid
import logging

logging.basicConfig(
  stream=sys.stdout,
  level=logging.INFO,
  format='[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s',
)

params = pika.URLParameters(os.environ['AMQP_URL'])
connection = pika.BlockingConnection(params)

channel = connection.channel()

def process_message(ch, method, properties, body):
  body = json.loads(body)

  logging.info("EVENT: %s %s" % (properties.type, body.get('id')))

  if properties.type == 'order:requested':
    return process_payment(body)


def process_payment(body):
  event = 'payment:declined'
  payment_status = 'DECLINED'

  if body.get('product').get('price') % 2 == 0:
    event = 'payment:approved'
    payment_status = 'APPROVED'

  channel.basic_publish(
    exchange='events',
    routing_key='',
    body=json.dumps({
      'id': str(uuid.uuid4()),
      'status': payment_status,
      'order_id': body.get('id')
    }),
    properties=pika.BasicProperties(
      type=event
    )
  )

def main():
  logging.info("start application with broker %s" % os.environ['AMQP_URL'])

  channel.basic_consume(
    auto_ack=True,
    queue='payments-api',
    on_message_callback=process_message
  )

  logging.info("starting consuming")

  channel.start_consuming()

if __name__ == '__main__':
  try:
    main()
  except KeyboardInterrupt:
    logging.info('Interrupted')
    
    try:
      sys.exit(0)
    except SystemExit:
      os._exit(0)
