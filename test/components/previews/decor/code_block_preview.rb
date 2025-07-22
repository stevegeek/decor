# @label CodeBlock
class ::Decor::CodeBlockPreview < ::Lookbook::Preview
  # CodeBlock
  # ---------
  #
  # Multi-line code blocks with syntax highlighting support.
  # Features include line numbers, copy functionality, filename display, and terminal style.
  # Supports highlighting specific lines and various programming languages.
  #
  # @group Examples
  # @label Basic Code Block
  def basic_code_block
    render ::Decor::CodeBlock.new do
      <<~CODE
        const numbers = [1, 2, 3, 4, 5];
        const doubled = numbers.map(n => n * 2);
        console.log("Doubled numbers:", doubled);
      CODE
    end
  end

  # @group Examples
  # @label Code Highlight
  def code_block_highlight
    render ::Decor::CodeBlock.new(
      language: "javascript",
      highlight: true
    ) do
      <<~JS
        const numbers = [1, 2, 3, 4, 5];
        const doubled = numbers.map(n => n * 2);
        console.log(doubled);
      JS
    end
  end

  # @group Examples
  # @label Code with Line Numbers
  def code_with_line_numbers
    render ::Decor::CodeBlock.new(
      language: "javascript",
      show_line_numbers: true
    ) do
      <<~JS
        function greet(name) {
          console.log(`Hello, ${name}!`);
          return `Welcome to our application, ${name}`;
        }
        
        greet('World');
      JS
    end
  end

  # @group Examples
  # @label Terminal Command
  def terminal_command
    render ::Decor::CodeBlock.new(style: :terminal) do
      <<~TERMINAL
        $ npm install
        > added 27 packages in 2s
        $ npm run dev
        > Local: http://localhost:5173/
      TERMINAL
    end
  end

  # @group Playground
  # @label Playground
  # @param language text
  # @param highlight toggle
  # @param show_line_numbers toggle
  # @param copy_button toggle
  # @param filename text
  # @param style select [default, terminal]
  def playground(
    language: "javascript",
    highlight: false,
    show_line_numbers: false,
    copy_button: false,
    filename: nil,
    style: :default
  )
    render ::Decor::CodeBlock.new(
      language: language,
      highlight: highlight,
      show_line_numbers: show_line_numbers,
      copy_button: copy_button,
      filename: filename,
      style: style
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

  # @group Languages
  # @label Ruby Code
  def ruby_code
    render ::Decor::CodeBlock.new(language: "ruby", highlight: true) do
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

  # @group Languages
  # @label Python Code
  def python_code
    render ::Decor::CodeBlock.new(language: "python", highlight: true) do
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

  # @group Languages
  # @label JSX Component
  def jsx_component
    render ::Decor::CodeBlock.new(language: "jsx", highlight: true) do
      <<~JSX
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
      JSX
    end
  end

  # @group Features
  # @label With Highlighted Lines
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

  # @group Features
  # @label With Filename
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

  # @group Features
  # @label With Copy Button
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

  # @group Terminal Style
  # @label Terminal Output
  def terminal_output
    render ::Decor::CodeBlock.new(style: :terminal) do
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

  # @group Terminal style
  # @label Terminal with Errors
  def terminal_with_errors
    render ::Decor::CodeBlock.new(
      style: :terminal,
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

  # @group Examples
  # @label Complete Example
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
