class Game

    attr_accessor :board, :player_1, :player_2

    WIN_COMBINATIONS = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [6, 4, 2]
    ]

    def initialize(p1 = Players::Human.new("X"), p2 = Players::Human.new("O"), board = Board.new)
        @player_1 = p1
        @player_2 = p2
        @board = board
    end

    def board
        @board
    end

    def current_player
        board.turn_count.even? ? @player_1 : @player_2
    end

    def won?
        WIN_COMBINATIONS.each {|win_combination|
            position_1 = board.cells[win_combination[0]]
            position_2 = board.cells[win_combination[1]]
            position_3 = board.cells[win_combination[2]]

            return win_combination if ((position_1 == "X" && position_2 == "X" && position_3 == "X") ||
                                    (position_1 == "O" && position_2 == "O" && position_3 == "O"))
        }
        return false
    end

    def draw?
        !won? && board.full? ? true : false
    end

    def over?
        won? || draw? ? true : false
    end

    def winner
        if won = won?
            board.cells[won.first]
        end
    end

    def turn
        puts "--------------------------------------"
        puts "player #{current_player.token}'s turn!"
        puts "Where would you like to play? (1-9):"
        board.display

        user_input = current_player.move(board)

        if board.valid_move?(user_input)
            board.update(user_input, current_player)
        else
            puts "That move is invalid."
            turn
        end
    end

    def play
        until over?
            turn
        end

        if won?
            puts "Congratulations #{winner}!"
        elsif draw?
            puts "Cat's Game!"
        end
        board.display
    end

end