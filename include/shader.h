#pragma once
#include <string>
#include "glad/glad.h"

class Shader{
public:
    Shader(const std::string t_vertexPath, const std::string t_fragmentPath);
    ~Shader();

    void setUniform1i(std::string t_name, int value);
    void setUniformMatrix4fv(std::string t_name, const float *t_values);
    void setUniformVector3fv(std::string t_name, const float *t_values);
    void setUniform1f(std::string t_name, float value);

    void use();
    void deleteProgram();
    void create(const std::string t_vertexPath, const std::string t_fragmentPath);
private:
    unsigned int ID;
private:
    unsigned int compileShader(GLenum shaderType, const char *shaderSource);
    unsigned int createProgram(unsigned int vertexShader, unsigned int fragmentShader);
    
    bool shaderInfo(unsigned int shaderNumber);
    bool programInfo(unsigned int programNumber);

    static std::string readFileContents(const std::string t_filename);

    //TODO: in future add uniform methods
};
