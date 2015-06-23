class CreateSupplierCategories < ActiveRecord::Migration
  def change
    create_table :supplier_categories do |t|
      t.string :name
      t.boolean :status
      t.boolean :protected
      t.string :code

      t.timestamps null: false
    end
  end
end
