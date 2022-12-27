Sequel.migration do
  change do
    create_table(:merchants) do
      primary_key :id
      String :name, null: false
      String :email, null: false
      String :cif, null: false
    end

    create_table(:shoppers) do
      primary_key :id
      String :name, null: false
      String :email, null: false
      String :nif, null: false
    end

    create_table(:orders) do
      primary_key :id
      Integer :merchant_id, null: false
      Integer :shopper_id, null: false
      BigDecimal :amount, size: [10, 2], null: false
      DateTime :created_at, null: false
      DateTime :completed_at
    end

    create_table(:disbursements) do
      primary_key :id
      Date :week_started_at, null: false
      BigDecimal :amount, size: [10, 2], null: false
      Integer :merchant_id, null: false
    end
  end
end
