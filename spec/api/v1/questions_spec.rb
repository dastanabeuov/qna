require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers in question' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }
    let(:attachment) { attachments.first }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:link) { links.first }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let(:comment) { comments.first }

    let(:api_path) { '/api/v1/questions/#{question.id}' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { format: :json, access_token: access_token.token } }

      it '- returns 200 status' do
        expect(response).to have_http_status(200)
      end

      context '- contains' do
        %w[id title body user_id created_at updated_at].each do |attr|
          it "- #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end

      context '- attachments ' do
        it '- included in question object' do
          expect(response.body).to have_json_size(attachments.size).at_path('attachments')
        end

        it '- contains url' do
          
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/url')
        end
      end

      context '- links ' do
        it '- included in question object' do
          expect(response.body).to have_json_size(links.size).at_path('links')
        end

        it '- contains url' do
          
          expect(response.body).to be_json_eql(link.url.to_json).at_path('links/0/url')
        end
      end

      context '- comments' do
        it '- included in question object' do
          expect(response.body).to have_json_size(comments.size).at_path('comments')
        end

        %w[id text user_id].each do |attr|
          it "- contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end

    def send_request(params = {})
      get api_path, params: { format: :json }.merge(params)
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:attrs) { attributes_for(:question, user: user) }
    let(:invalid_attrs) { attributes_for(:question, title: :invalid, user: user) }

    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'Authorized' do
      context '- invalid attributes' do
        it '- returns 422 status' do
          post api_path, params: { access_token: access_token.token, question: invalid_attrs, format: :json }
          expect(response).to have_http_status(422)
        end
      end

      context "- valid attributes" do
        before { post api_path, params: { access_token: access_token.token, question: attrs, format: :json } }
    
        it '- returns status 201-Created' do
          expect(response).to have_http_status(201)
        end
  
        %w[title body user_id created_at updated_at attachments comments].each do |attr|
          it "- contains #{attr}" do
            expect(response.body).to have_json_path(attr)
          end
        end
  
        %w[title body].each do |attr|
          it "- set #{attr}" do
            expect(response.body).to be_json_eql(attrs[attr.to_sym].to_json).at_path(attr)
          end
        end
  
        it '- set user_id' do
          expect(response.body).to be_json_eql(user.id.to_json).at_path('user_id')
        end
      end
    end

    def send_request(params = {})
      post api_path, params: { format: :json }.merge(params)
    end
  end
end