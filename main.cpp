#include "glad/glad.h"
#include <GLFW/glfw3.h>
#include <iostream>

#include "shader.h"

static unsigned int WINDOW_WIDTH = 800;
static unsigned int WINDOW_HEIGHT = 600;

void errorCallback(int error, const char* description);
void keyboardCallback(GLFWwindow *window, int key, int scancode, int action, int mods);
void resizeCallback(GLFWwindow *window, int width, int height);
unsigned int createCanvas();

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

    if(!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)){
        std::cout << "Error loading glad" << std::endl;
        return 1;
    }

    // set callbacks
    glfwSetFramebufferSizeCallback(window, resizeCallback);
    glfwSetKeyCallback(window, keyboardCallback);
    glfwSetErrorCallback(errorCallback);


    resizeCallback(window, WINDOW_WIDTH, WINDOW_HEIGHT);

    //create canvas
    unsigned int canvas = createCanvas();
    // create shader
    Shader shader("./assets/vertex.glsl", "./assets/fragment.glsl");

    while(!glfwWindowShouldClose(window)){

        if(glfwGetKey(window, GLFW_KEY_R) == GLFW_PRESS){
            shader.create("./assets/vertex.glsl", "./assets/fragment.glsl");
        }

        //set uniforms
        //draw call here
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        shader.use();
        shader.setUniform1f("iTime", glfwGetTime());
        float resolution[3] = {(float)WINDOW_WIDTH, (float)WINDOW_HEIGHT, 0.0};
        shader.setUniformVector3fv("iResolution", resolution);
        glBindVertexArray(canvas);
        glDrawArrays(GL_TRIANGLES, 0, 6);

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
    WINDOW_WIDTH = width;
    WINDOW_HEIGHT = height;
    glViewport(0, 0, width, height);
}

unsigned int createCanvas(){

    float vertices[] = {
        -1.0, -1.0,
         1.0,  1.0,
         1.0, -1.0,
        -1.0, -1.0,
        -1.0,  1.0,
         1.0,  1.0
    };
    unsigned int VBO, objectID;
    glGenBuffers(1, &VBO);
    glGenVertexArrays(1, &objectID);
    glBindVertexArray(objectID);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void*)0); // positions

    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);

    return objectID;
}
