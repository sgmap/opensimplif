require 'rails_helper'

describe Individual do
  it { is_expected.to have_db_column(:nom) }
  it { is_expected.to have_db_column(:prenom) }
  it { is_expected.to belong_to(:dossier) }
end
