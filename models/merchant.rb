class Merchant < Sequel::Model
end

# Table: merchants
# Columns:
#  id    | integer | PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY
#  name  | text    | NOT NULL
#  email | text    | NOT NULL
#  cif   | text    | NOT NULL
# Indexes:
#  merchants_pkey | PRIMARY KEY btree (id)