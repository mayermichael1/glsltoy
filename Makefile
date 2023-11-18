#  use alias bake to generate compile_commands.json
CXX := g++
CXXFLAGS := -Wall -Wextra -Werror
BUILD_DIR := ./build
LDFLAGS :=
LDLIBS :=  -lglfw
CPPFLAGS :=  -Iinclude/

OBJECTS := $(BUILD_DIR)/main.o
OBJECTS += $(BUILD_DIR)/glad.o
OBJECTS += $(BUILD_DIR)/shader.o
# add objects here like this:
# OBJECTS += $(BUILD_DIR)/object.o

CXXFLAGS += -Og -g
#CXXFLAGS += -O2

$(BUILD_DIR)/GLSLToy: $(OBJECTS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(OBJECTS) -o $(BUILD_DIR)/GLSLToy $(LDFLAGS) $(LDLIBS)

# program entry point
$(BUILD_DIR)/main.o: main.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c main.cpp -o $(BUILD_DIR)/main.o

$(BUILD_DIR)/glad.o: src/glad.c include/glad/glad.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c src/glad.c -o $(BUILD_DIR)/glad.o

$(BUILD_DIR)/shader.o: src/shader.cpp include/shader.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c src/shader.cpp -o $(BUILD_DIR)/shader.o

# Build all Objects here
# $(BUILD_DIR)/object.o: src/object.cpp include/object.h
# 	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c src/object.cpp -o $(BUILD_DIR)/object.o

.PHONY: clean
clean: 
	rm -rf $(BUILD_DIR)/*
	rm ./compile_commands.json

