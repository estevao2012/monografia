class CreateCitys < ActiveRecord::Migration
  def change
    create_table :citys do |t|
      t.string :nome
      t.string :uf
      t.string :populacao
      t.string :pib
      t.string :estado_id
      t.string :codigo_ibg
      t.multi_polygon :geom

      t.timestamps null: false
    end
  end
end
