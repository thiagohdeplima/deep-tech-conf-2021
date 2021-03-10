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


Sales.Repo.insert!(%Sales.SaleContext.Product{
  name: "MacBook Pro",
  price: 1_459_999,
  quantity: 10
})