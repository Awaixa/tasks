require 'rails_helper'

RSpec.describe 'Tasks APIs', type: :request do
  let(:headers) { { 'Content-Type' => 'application/json' } }

  def tasks_details(tasks)
    tasks.map do |task|
      {
        id: task.uuid,
        type: 'tasks',
        attributes: {
          name: task.name,
          description: task.description,
          priority: task.priority,
          category: task.category,
        },
      }
    end
  end

  describe 'GET /tasks' do
    context 'when no tasks' do
      before { get '/tasks', headers: headers }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq({data: []}.to_json) }
      it { expect(response.headers['Content-Type']).to include 'application/json'}
    end

    context 'when there are tasks' do
      let!(:task1) { FactoryBot.create :task, name: 'Task1', description: 'Task1Description' }
      let!(:task2) { FactoryBot.create :task, name: 'Task2', description: 'Task2Description' }
      let!(:task3) { FactoryBot.create :task, name: 'Task3', description: 'Task3Description' }

      before { get '/tasks', headers: headers }

      it { expect(response.body).to eq({data: tasks_details([task1, task2, task3])}.to_json) }
    end
  end

  describe 'GET /tasks/:id' do
    context 'when id not exists' do
      before { get '/tasks/123', headers: headers }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.headers['Content-Type']).to include 'application/json'}
      
      it 'returns json error' do
        expect(response.body).to eq(
          {
            errors: [
              {
                code: 'not_found_error',
                detail: "Couldn't find Task",
                status: 'not_found',
              },
            ],
          }.to_json
        )
      end
    end

    context 'when id present' do
      let!(:task) { FactoryBot.create :task }

      before { get "/tasks/#{task.uuid}", headers: headers }

      it { expect(response.body).to eq({data: tasks_details([task]).first}.to_json) }
    end
  end
end
