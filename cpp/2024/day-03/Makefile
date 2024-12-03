CC = clang++
CC_FLAGS = -std=c++23

MAIN = main.cpp
OUT = solve.out

EXAMPLE_FILE = example.txt
INPUT_FILE = input.txt

# Execute the example by default
run:
	@$(CC) $(CC_FLAGS) $(MAIN) -o $(OUT)
	@./$(OUT) $(EXAMPLE_FILE)

solve:
	@$(CC) $(CC_FLAGS) $(MAIN) -o $(OUT)
	@./$(OUT) $(INPUT_FILE)
