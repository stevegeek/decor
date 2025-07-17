# @label CodeBlock
class ::Decor::CodeBlockPreview < ::Lookbook::Preview
  # CodeBlock
  # ---------
  #
  # Multi-line code blocks with syntax highlighting support
  #
  # @label Playground
  # @param language text
  # @param highlight toggle
  # @param show_line_numbers toggle
  # @param copy_button toggle
  # @param filename text
  # @param variant select [default, terminal]
  def playground(
    language: "javascript",
    highlight: false,
    show_line_numbers: false,
    copy_button: false,
    filename: nil,
    variant: :default
  )
    render ::Decor::CodeBlock.new(
      language: language,
      highlight: highlight,
      show_line_numbers: show_line_numbers,
      copy_button: copy_button,
      filename: filename,
      variant: variant
    ) do
      <<~CODE
        function greet(name) {
          console.log(`Hello, ${name}!`);
          return `Welcome to our application, ${name}`;
        }
        
        greet('World');
      CODE
    end
  end

  # @label Basic code block
  def basic
    render ::Decor::CodeBlock.new do
      <<~CODE
        const numbers = [1, 2, 3, 4, 5];
        const doubled = numbers.map(n => n * 2);
        console.log(doubled);
      CODE
    end
  end

  # @label With language
  def with_language_highlighting
    render Decor::Element.new(classes: "space-y-6") do |el|
      el.div do
        el.h4(class: "font-semibold mb-2") { "Ruby:" }
        el.render ::Decor::CodeBlock.new(language: "ruby", highlight: true) do
          <<~RUBY
            class User < ApplicationRecord
              has_many :posts
              validates :email, presence: true, uniqueness: true
              
              def full_name
                "\#{first_name} \#{last_name}"
              end
            end
          RUBY
        end
      end

      el.div do
        el.h4(class: "font-semibold mb-2") { "Python:" }
        el.render ::Decor::CodeBlock.new(language: "python", highlight: true) do
          <<~PYTHON
            def fibonacci(n):
                if n <= 1:
                    return n
                return fibonacci(n-1) + fibonacci(n-2)
            
            # Calculate first 10 fibonacci numbers
            for i in range(10):
                print(f"F({i}) = {fibonacci(i)}")
          PYTHON
        end
      end
    end
  end

  # @label With line numbers
  def with_line_numbers
    render ::Decor::CodeBlock.new(
      language: "javascript",
      show_line_numbers: true
    ) do
      <<~JS
        import React, { useState } from 'react';

        function Counter() {
          const [count, setCount] = useState(0);
          
          return (
            <div>
              <p>You clicked {count} times</p>
              <button onClick={() => setCount(count + 1)}>
                Click me
              </button>
            </div>
          );
        }
        
        export default Counter;
      JS
    end
  end

  # @label With highlighted lines
  def with_highlighted_lines
    render ::Decor::CodeBlock.new(
      language: "ruby",
      show_line_numbers: true,
      highlight_lines: [3, 4, 5]
    ) do
      <<~RUBY
        def process_payment(amount, card_number)
          # Validate the amount
          if amount <= 0
            raise ArgumentError, "Amount must be positive"
          end
          
          # Process the payment
          payment_gateway.charge(amount, card_number)
        end
      RUBY
    end
  end

  # @label With filename
  def with_filename
    render ::Decor::CodeBlock.new(
      filename: "app/controllers/users_controller.rb",
      language: "ruby"
    ) do
      <<~RUBY
        class UsersController < ApplicationController
          before_action :authenticate_user!
          
          def index
            @users = User.all
          end
          
          def show
            @user = User.find(params[:id])
          end
        end
      RUBY
    end
  end

  # @label With copy button
  def with_copy_button
    render ::Decor::CodeBlock.new(
      copy_button: true,
      language: "bash"
    ) do
      <<~BASH
        # Install dependencies
        npm install
        
        # Run development server
        npm run dev
        
        # Build for production
        npm run build
      BASH
    end
  end

  # @label Terminal variant
  def terminal_variant
    render ::Decor::CodeBlock.new(variant: :terminal) do
      <<~TERMINAL
        $ npm create vite@latest my-app
        > Need to install the following packages:
        > create-vite@5.0.0
        > Ok to proceed? (y)
        $ cd my-app
        $ npm install
        > added 27 packages, and audited 28 packages in 2s
        > found 0 vulnerabilities
        $ npm run dev
        > dev
        > vite
        > 
        >   VITE v5.0.0  ready in 320 ms
        > 
        >   ➜  Local:   http://localhost:5173/
        >   ➜  Network: use --host to expose
      TERMINAL
    end
  end

  # @label Terminal with errors
  def terminal_with_errors
    render ::Decor::CodeBlock.new(
      variant: :terminal,
      highlight_lines: [4, 5]
    ) do
      <<~TERMINAL
        $ npm test
        > test
        > jest
        > FAIL  src/App.test.js
        >   ● Test suite failed to run
        > 
        >     Cannot find module './components/Header' from 'src/App.js'
        $ 
      TERMINAL
    end
  end

  # @label Complete example
  def complete_example
    render ::Decor::CodeBlock.new(
      filename: "src/components/TodoList.jsx",
      language: "jsx",
      show_line_numbers: true,
      copy_button: true,
      highlight_lines: [8, 9, 10]
    ) do
      <<~JSX
        import React, { useState } from 'react';
        import TodoItem from './TodoItem';

        function TodoList() {
          const [todos, setTodos] = useState([]);
          const [inputValue, setInputValue] = useState('');
          
          const addTodo = () => {
            if (inputValue.trim()) {
              setTodos([...todos, { id: Date.now(), text: inputValue }]);
              setInputValue('');
            }
          };
          
          return (
            <div className="todo-list">
              <h1>My Todo List</h1>
              <div className="input-group">
                <input
                  type="text"
                  value={inputValue}
                  onChange={(e) => setInputValue(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && addTodo()}
                />
                <button onClick={addTodo}>Add</button>
              </div>
              <ul>
                {todos.map(todo => (
                  <TodoItem key={todo.id} todo={todo} />
                ))}
              </ul>
            </div>
          );
        }
        
        export default TodoList;
      JSX
    end
  end
end
