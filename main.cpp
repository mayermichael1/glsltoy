#include "glad/glad.h"
#include <GLFW/glfw3.h>
#include <iostream>

static const unsigned int WINDOW_WIDTH = 800;
static const unsigned int WINDOW_HEIGHT = 600;

void errorCallback(int error, const char* description);
void keyboardCallback(GLFWwindow *window, int key, int scancode, int action, int mods);
void resizeCallback(GLFWwindow *window, int width, int height);

int main(void){

    if(!glfwInit()){
        std::cout << "Error initializing GLFW" << std::endl;
        return 1;
    }

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    //GLFWWindow window* = 
    GLFWwindow *window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "ShaderTest", NULL, NULL);
    if(!window){
        std::cout << "Error creating window" << std::endl;
    }

    glfwMakeContextCurrent(window);

    // set callbacks
    glfwSetFramebufferSizeCallback(window, resizeCallback);
    glfwSetKeyCallback(window, keyboardCallback);
    glfwSetErrorCallback(errorCallback);


    if(!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)){
        std::cout << "Error loading glad" << std::endl;
        return 1;
    }

    resizeCallback(window, WINDOW_WIDTH, WINDOW_HEIGHT);

    while(!glfwWindowShouldClose(window)){
        glfwSwapBuffers(window);
        glfwPollEvents(); 
    }

    glfwDestroyWindow(window);

    glfwTerminate();
    return 0;
}

void errorCallback(int error, const char* description){
    std::cout << "GLFW Error: " << error << " -> " << description << std::endl;
}
void keyboardCallback(GLFWwindow *window, int key, int scancode, int action, int mods){
    //supress warning unused variable
    (void)scancode;
    (void)mods;

    if(key == GLFW_KEY_ESCAPE && action == GLFW_PRESS){
        glfwSetWindowShouldClose(window, GLFW_TRUE);
    }
}
void resizeCallback(GLFWwindow *window, int width, int height){
    (void)window;
    std::cout << "Window resized to: " << width << "x"  << height << std::endl;
    glViewport(0, 0, width, height);
}
