class Shopper < Sequel::Model
end

# Table: shoppers
# Columns:
#  id    | integer | PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY
#  name  | text    | NOT NULL
#  email | text    | NOT NULL
#  nif   | text    | NOT NULL
# Indexes:
#  shoppers_pkey | PRIMARY KEY btree (id)