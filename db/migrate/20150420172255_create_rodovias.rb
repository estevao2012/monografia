class CreateRodovias < ActiveRecord::Migration
  def change
    create_table :rodovias do |t|
    	t.string :br
    	t.string :uf
    	t.string :codigo
    	t.string :local_de_i
    	t.string :local_de_f
    	t.integer :km_inicial
    	t.integer :km_final
    	t.decimal :extensao, precision: 8
    	t.string :superficie
    	t.string :federal_co
    	t.string :federal__1
    	t.string :federal__2
    	t.string :estadual_c
    	t.string :superfic_1
    	t.string :mpv_082_20
    	t.string :concessao_
    	t.multi_line_string :geom
      t.timestamps null: false
    end
  end
end
