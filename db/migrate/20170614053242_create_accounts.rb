class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |a|
      a.string :type
      a.integer :current_balance
      a.integer :statement_balance
      a.integer :credit_limit
      a.date    :due_date
    end
  end
end
