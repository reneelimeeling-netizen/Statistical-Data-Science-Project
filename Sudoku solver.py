# Import libraries
import tkinter as tk
from tkinter import filedialog, messagebox
import time

# Load Sudoku puzzle from csv file or txt file
def load_sudoku():
    file_path = filedialog.askopenfilename(filetypes=[("Sudoku files", "*.csv *.txt"), ("All files", "*.*")])
    if not file_path:
        return None

    # Ensure the Sudoku puzzle uploaded is in the correct 9x9 format
    board = []
    try:
        # First we validate if the Sudoku puzzle uploaded is in a 9x9 grid 
        
        with open(file_path, newline='') as file:
            for line in file:
                parts = line.strip().replace(',', ' ').split() # Then we process each row in the file, then replace commas with spaces
                row = [int(x) if x.isdigit() else 0 for x in parts] # Now convert each digit into an integer, and 0 into empty cells
                if row:
                    board.append(row)
                    
        if len(board) != 9 or any(len(row) != 9 for row in board): 
            raise ValueError("File must contain a 9x9 grid")

        update_board(board)
        messagebox.showinfo("Loaded", "File loaded successfully")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to load puzzle: {e}")

# Find next empty cell in the Sudoku grid, represented by 0
def find_empty_cell(board):
    for i in range(9):
        for j in range(9):
            if board[i][j] == 0:
                return (i, j)  
    return None

# Before placing a number, we must check if it is valid and follows the Sudoku rules
def valid(board, num, pos):
    row, col = pos # tuple unpacking, to make code more readable
    
    for i in range(9): # Check row
        if board[pos[0]][i] == num and i != col:
            return False # this means the number is already in the row

    for i in range(9): # Check column
        if board[i][col] == num and i != row:
            return False # Similarly, this means the number is already in the column

    box_x = col // 3 # check which 3x3 box we're in
    box_y = row // 3

    for i in range(box_y*3, box_y*3+3): # Now we check if the number is already in the 3x3 box
        for j in range(box_x*3, box_x*3+3):
            if board[i][j] == num and (i, j) != pos:
                return False 

    return True

# Backtracking algorithm with GUI updates
def solve_gui(board, labels, window): # board represents the Sudoku grid, labels is for the GUI widgets and window is the GUI window object
    empty = find_empty_cell(board) # First we find an empty cell
    if not empty:
        return True  # If there no more empty cells, the Sudoku is solved
    else:
        row, col = empty

    for i in range(1, 10): # The algorithm will try numbers 1 to 9 
        if valid(board, i, (row, col)):
            board[row][col] = i # If a number is valid, it will be placed in the empty cell
            labels[row][col].config(text=str(i), fg="green") # Then we update the GUI label to show the placed number
            window.update() # We refresh the GUI to show the changes
            time.sleep(0.03)  # Delay to visualize the solving process

            if solve_gui(board, labels, window):
                return True

            board[row][col] = 0
            labels[row][col].config(text="", fg="black")
            window.update()
            time.sleep(0.03)  # Delay to visualize the backtracking process

    return False    

# Function to load Sudoku puzzle from CSV file or txt file 
def update_board(new_board):
    global board, labels # This is to make sure after we modify the board and labels, the changes are reflected throughout the whole script
    board = new_board
    for i in range(9):
        for j in range(9):
            num = board[i][j]
            labels[i][j].config(text=str(num) if num != 0 else "", fg="black")


def solve_sudoku():
    start = time.time() # This records the time taken to solve 
    if solve_gui(board, labels, window):
        messagebox.showinfo("Solved", f"Completed in {time.time() - start:.2f} seconds")
    else:
        messagebox.showerror("Error", "No solution found")

# Setup GUI
window = tk.Tk()
window.title("Sudoku Solver Using Backtracking")
window.geometry('700x800')

frame = tk.Frame(window)
frame.pack(pady=10)

labels = []
board = [[0 for _ in range(9)] for _ in range(9)] # This is to initialize an empty 9x9 Sudoku board

for i in range(9): # Create 9x9 grid display
    row_labels = []
    for j in range(9):
        top = 3 if i % 3 == 0 else 1
        left = 3 if j % 3 == 0 else 1
        bottom = 3 if i == 8 else 0
        right = 3 if j == 8 else 0

        label = tk.Label(frame, text="", width=2, height=1, font=("Arial", 26), borderwidth=1, relief="solid")
        label.grid(row=i, column=j)

        if j % 3 == 0 and j != 0: # Add padding to seperate the 3x3 boxes to make it easier to see
            label.grid_configure(padx=(2, 0))  
        if i % 3 == 0 and i != 0:
            label.grid_configure(pady=(2, 0))
        row_labels.append(label)
    labels.append(row_labels)

# Setup buttons
button_frame = tk.Frame(window)
button_frame.pack(pady=20)

load_button = tk.Button(button_frame, text="Load file", command=load_sudoku)
load_button.pack(pady=10) # We decided to place the buttons vertically 

solve_button = tk.Button(button_frame, text="Solve puzzle", command=solve_sudoku)
solve_button.pack(pady=10)

exit_button = tk.Button(button_frame, text="Exit", command=window.destroy)
exit_button.pack(pady=10)

window.mainloop() # This line ensures the program stays in the loop until the window is closed