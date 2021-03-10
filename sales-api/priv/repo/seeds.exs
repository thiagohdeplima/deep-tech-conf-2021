# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sales.Repo.insert!(%Sales.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


Sales.Repo.insert(%Sales.SaleContext.Product{
  id: "1c82b906-bd41-408b-b2c8-18641905795e",
  name: "MacBook Pro",
  price: 14_599_99,
  quantity: 10
})

Sales.Repo.insert(%Sales.SaleContext.Product{
  id: "509d99f9-83c8-4817-904b-18861f0e73a0",
  name: "MacBook Air",
  price: 12_900_00,
  quantity: 10
})