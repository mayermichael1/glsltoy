#include "shader.h"
#include <fstream>
#include <iostream>

Shader::Shader(const std::string t_vertexPath, const std::string t_fragmentPath){
    create(t_vertexPath, t_fragmentPath);
}


Shader::~Shader(){
    deleteProgram();
}

void Shader::create(const std::string t_vertexPath, const std::string t_fragmentPath){
    // read file contents
    std::string vertexShaderSource = Shader::readFileContents(t_vertexPath);
    std::string fragmentShaderSource = Shader::readFileContents(t_fragmentPath);

    // create shaders
    unsigned int vertexShader = compileShader(GL_VERTEX_SHADER, vertexShaderSource.c_str());
    unsigned int fragmentShader = compileShader(GL_FRAGMENT_SHADER, fragmentShaderSource.c_str());

    // create program
    ID = createProgram(vertexShader, fragmentShader);
}

void Shader::use(){
    glUseProgram(ID);
}

void Shader::deleteProgram(){
    std::cout << "Deleted Shader Program" << std::endl;
    glDeleteProgram(ID);
}

void Shader::setUniform1i(std::string t_name, int t_value){
    use();
    glUniform1i(glGetUniformLocation(ID, t_name.c_str()), t_value);
}

void Shader::setUniform1f(std::string t_name, float t_value){
    use();
    glUniform1f(glGetUniformLocation(ID, t_name.c_str()), t_value);
}

void Shader::setUniformMatrix4fv(std::string t_name, const float *t_values){
    use();
    glUniformMatrix4fv(glGetUniformLocation(ID, t_name.c_str()), 1, GL_FALSE, t_values);
}

void Shader::setUniformVector3fv(std::string t_name, const float *t_values){
    use();
    glUniform3fv(glGetUniformLocation(ID, t_name.c_str()), 1, t_values);
}

void Shader::setUniformVector4fv(std::string t_name, const float *t_values){
    use();
    glUniform4fv(glGetUniformLocation(ID, t_name.c_str()), 1, t_values);
}

unsigned int Shader::compileShader(GLenum shaderType, const char *shaderSource){ 
    unsigned int shader;
    shader = glCreateShader(shaderType);
    glShaderSource(shader, 1, &shaderSource, NULL);
    glCompileShader(shader);
    shaderInfo(shader);
    return shader;
}

unsigned int Shader::createProgram(unsigned int vertexShader, unsigned int fragmentShader){ 
    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);

    glLinkProgram(shaderProgram);
    programInfo(shaderProgram);

    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    return shaderProgram;
}

bool Shader::shaderInfo(unsigned int shaderNumber){
    int success;
    char infoLog[512];
    glGetShaderiv(shaderNumber, GL_COMPILE_STATUS, &success);

    if(!success){
        glGetShaderInfoLog(shaderNumber, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::COMPILATION_FAILED\n" << infoLog << std::endl;
        return false;
    }
    return true;
}

bool Shader::programInfo(unsigned int programNumber){
    int success;
    char infoLog[512];

    glGetProgramiv(programNumber, GL_LINK_STATUS, &success);
    if(!success){
        glGetProgramInfoLog(programNumber,  512, NULL, infoLog);
        std::cout << "ERROR::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
        return false;
    }
    return true;
}

std::string Shader::readFileContents(const std::string t_filename){
    std::ifstream file;
    file.open(t_filename);
    std::string line;
    std::string output;
    if(file.is_open()){
        while(std::getline(file, line)){
            output.append(line);
            output.append("\n");
        }
        file.close();
    }else{
        std::cout << "Could not open file: " << t_filename << std::endl;
    }
    return output;
}
