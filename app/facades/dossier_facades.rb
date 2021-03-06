class DossierFacades
  # TODO: rechercher en fonction de la personne/email
  def initialize(dossier_id, _email, champ_id = nil)
    @dossier = Dossier.not_archived.find(dossier_id)
    @champ_id = champ_id
  end

  def dossier
    @dossier.decorate
  end

  def last_notifications
    @dossier.notifications.order('updated_at DESC')
  end

  def champs
    @dossier.ordered_champs.includes(:type_de_champ)
  end

  def entreprise
    @dossier.entreprise.decorate unless @dossier.entreprise.nil? || @dossier.entreprise.siren.blank?
  end

  def etablissement
    @dossier.etablissement
  end

  def pieces_justificatives
    @dossier.ordered_pieces_justificatives
  end

  def types_de_pieces_justificatives
    @dossier.types_de_piece_justificative.order('order_place ASC')
  end

  attr_reader :champ_id

  def champ
    Champ.find(champ_id)
  rescue
    nil
  end

  def commentaires
    @dossier.ordered_commentaires.where(champ_id: @champ_id).includes(:piece_justificative).decorate
  end

  def procedure
    @dossier.procedure
  end

  def cerfas_ordered
    @dossier.cerfa.order('created_at DESC')
  end

  def invites
    @dossier.invites
  end

  def individual
    @dossier.individual
  end

  def commentaires_files
    PieceJustificative.where(dossier_id: @dossier.id, type_de_piece_justificative_id: nil)
  end

  def followers
    Gestionnaire.joins(:follows).where("follows.dossier_id=#{@dossier.id}")
  end
end
