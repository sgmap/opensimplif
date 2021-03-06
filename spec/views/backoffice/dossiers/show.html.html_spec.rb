require 'rails_helper'

describe 'backoffice/dossiers/show.html.haml', type: :view do
  let!(:dossier) { create(:dossier, :with_entreprise, state: state) }
  let(:state) { 'draft' }
  let(:dossier_id) { dossier.id }
  let(:gestionnaire) { create(:gestionnaire) }

  before do
    sign_in gestionnaire
    assign(:facade, (DossierFacades.new dossier.id, gestionnaire.email))

    @request.env['PATH_INFO'] = 'backoffice/user'
  end

  context 'on the dossier gestionnaire page' do
    before do
      render
    end

    it 'button Modifier les document est present' do
      expect(rendered).not_to have_content('Modifier les documents')
      expect(rendered).not_to have_css('#UploadPJmodal')
    end

    it 'enterprise informations are present' do
      expect(rendered).to have_selector('#infos_entreprise')
    end

    it 'dossier informations are present' do
      expect(rendered).to have_selector('#infos_dossier')
    end

    context 'edit link are present' do
      it 'edit carto' do
        expect(rendered).not_to have_selector('a[id=modif_carte]')
      end

      it 'edit description' do
        expect(rendered).not_to have_selector('a[id=modif_description]')
      end

      it 'Editer mon dossier button doesnt present' do
        expect(rendered).not_to have_css('#maj_infos')
      end
    end
  end
end
