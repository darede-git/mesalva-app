class CreateSisuReports < ActiveRecord::Migration[5.2]
  def change
    create_table :sisu_reports do |t|
      t.string :no_ies
      t.string :sg_ies
      t.string :ds_organizacao_academica
      t.string :ds_categoria_adm
      t.string :no_campus
      t.string :sg_uf_campus
      t.string :no_municipio_campus
      t.string :ds_regiao
      t.string :no_curso
      t.string :ds_grau
      t.string :ds_turno
      t.string :ds_periodicidade
      t.integer :qt_semestre
      t.integer :nu_vagas_autorizadas
      t.integer :qt_vagas_ofertadas
      t.string :tp_modalidade
      t.string :ds_mod_concorrencia
      t.integer :peso_redacao
      t.integer :peso_linguagens
      t.integer :peso_matematica
      t.integer :peso_ciencias_humanas
      t.integer :peso_ciencias_natureza
      t.float :nota_corte
      t.integer :year
      t.integer :edition
      t.boolean :afrodecendente
      t.boolean :carente
      t.boolean :publica
      t.boolean :deficiencia
      t.boolean :indigena
      t.boolean :trans

      t.timestamps
    end
  end
end
