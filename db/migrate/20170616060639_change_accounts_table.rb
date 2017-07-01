class ChangeAccountsTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :accounts,:type,:card_type
  end
end
