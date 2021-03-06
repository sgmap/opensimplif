class PreferenceListDossier < ActiveRecord::Base
  belongs_to :gestionnaire
  belongs_to :procedure

  def table_attr
    return attr if table.nil? || table.empty?
    table + '.' + attr
  end

  def table_with_s_attr
    return 'dossiers.' + attr if table.nil? || table.empty?
    table + 's' + '.' + attr
  end

  class << self
    def available_columns_for(procedure_id = nil)
      columns = {
        dossier: columns_dossier,
        user: columns_user
      }

      columns = columns.merge(champs: columns_champs_procedure(procedure_id)) unless procedure_id.nil?

      columns
    end

    private

    def columns_dossier
      table = nil

      {
        dossier_id: create_column('N°', table, 'id', 'id', 1),
        created_at: create_column('Créé le', table, 'created_at', 'first_creation', 2),
        updated_at: create_column('Mise à jour le', table, 'updated_at', 'last_update', 2)
      }
    end

    def columns_procedure
      table = 'procedure'

      {
        libelle: create_column('Libellé procédure', table, 'libelle', 'libelle', 4),
        organisation: create_column('Organisation', table, 'organisation', 'organisation', 3),
        direction: create_column('Direction', table, 'direction', 'direction', 3)
      }
    end

    def columns_entreprise
      table = 'entreprise'

      {
        siren: create_column('SIREN', table, 'siren', 'siren', 2),
        forme_juridique: create_column('Forme juridique', table, 'forme_juridique', 'forme_juridique', 3),
        nom_commercial: create_column('Nom commercial', table, 'nom_commercial', 'nom_commercial', 3),
        raison_sociale: create_column('Raison sociale', table, 'raison_sociale', 'raison_sociale', 3),
        siret_siege_social: create_column('SIRET siège social', table, 'siret_siege_social', 'siret_siege_social', 2),
        date_creation: create_column('Date de création', table, 'date_creation', 'date_creation', 2)
      }
    end

    def columns_etablissement
      table = 'etablissement'

      {
        siret: create_column('SIRET', table, 'siret', 'siret', 2),
        libelle: create_column('Nom établissement', table, 'libelle_naf', 'libelle_naf', 3),
        code_postal: create_column('Code postal', table, 'code_postal', 'code_postal', 1)
      }
    end

    def columns_user
      table = 'user'
      {
        email: create_column('Email', table, 'email', 'email', 2)
      }
    end

    def columns_france_connect
      table = 'france_connect_information'

      {
        gender: create_column('Civilité (FC)', table, 'gender', 'gender_fr', 1),
        given_name: create_column('Prénom (FC)', table, 'given_name', 'given_name', 2),
        family_name: create_column('Nom (FC)', table, 'family_name', 'family_name', 2)
      }
    end

    def columns_champs_procedure(procedure_id)
      table = 'champs'

      procedure = Procedure.find_by(id: procedure_id)
      if procedure
        procedure.types_de_champ.inject({}) do |acc, type_de_champ|
          acc = acc.merge("type_de_champ_#{type_de_champ.id}" => create_column(type_de_champ.libelle, table, type_de_champ.id, 'value', 2)) if type_de_champ.field_for_list?
          acc
        end
      end
    end

    def create_column(libelle, table, attr, attr_decorate, bootstrap_lg)
      {
        libelle: libelle,
        table: table,
        attr: attr,
        attr_decorate: attr_decorate,
        bootstrap_lg: bootstrap_lg,
        order: nil,
        filter: nil
      }
    end
  end
end
