require 'swagger'

describe 'API' do
    path '/api/v1/posts/{post_id}/comments' do
        post 'Creates a comment' do
            tags 'Comments'
            consumes 'application/json', 'application/xml'
            parameter name: :post_id, in: :path, type: :string
            parameter name: :comment, in: :body, schema: {
                type: :object,
                properties: {
                    content: { type: :string }
                },
                required: [ 'content' ]
            }
            response '201', 'comment created' do
                let(:comment) { { content: 'test' } }
                run_test!
            end

            response '422', 'invalid request' do
                let(:comment) { { content: nil } }
                run_test!
            end
        end
    end
end

path '/api/v1/posts/{post_id}' do
    get 'Retrieves comments for a post' do
        tags 'Comments'
        produces 'application/json', 'application/xml'
        parameter name: :post_id, in: :path, type: :string

        response '200', 'comments found' do
            schema type: :object,
                properties: {
                    comments: { type: :object }
                },
                required: [ 'comments' ]

            let(:post) { Post.find(post_id).comments }
            run_test!
        end

        response '404', 'post not found' do
            let(:post_id) { 'invalid' }
            run_test!
        end
    end
end