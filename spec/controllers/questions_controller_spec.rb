require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

=begin

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      #questions = create_list(:question, 3) 
      #question1 = FactoryBot.create(:question)
      #question2 = FactoryBot.create(:question)
      #get :index
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      #get :index
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      #get :show, params: { id: question }
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      #get :show, params: { id: question }

      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end    
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      #get :edit, params: { id: question }
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      #get :edit, params: { id: question }

      expect(response).to render_template :edit
    end
  end

=end

  describe 'POST(PUT) #create' do
    context 'with valid atributes' do
      it 'save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirectto show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid atributes' do
      it 'not save a question in the database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'redirectto new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

=begin

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        
        expect(assigns(:question)).to eq question
      end
      
      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        
        expect(question.body).to eq 'new body'
      end

      it 'redirectto update question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      
      it 'does not change question' do
        #patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'renders edit view' do
        #patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
      
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    it 'delete the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect_to index view' do
      delete :destroy, params: { id: question }

       expect(response).to redirect_to questions_path
    end
  end

=end

end