require 'rails_helper'

describe AdministrationsController, type: :controller do
  let(:administration) { create :administration }

  describe 'GET #index' do
    subject { get :index }

    context 'when administration user is not logged in' do
      it { expect(subject.status).to eq 302 }
    end

    context 'when administration user is logged in' do
      before do
        sign_in administration
      end

      it { expect(subject.status).to eq 200 }
    end
  end

  describe 'POST #create' do
    let(:email) { 'plop@plop.com' }
    let(:password) { 'password' }

    before do
      sign_in administration
    end

    subject { post :create, administrateur: {email: email, password: password} }

    context 'when email and password are correct' do
      it 'add new administrateur in database' do
        expect { subject }.to change(Administrateur, :count).by(1)
      end
    end

    context 'when email or password are missing' do
      let(:email) { '' }

      it { expect { subject }.to change(Administrateur, :count).by(0) }
    end
  end
end
