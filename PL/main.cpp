#include <GL/glut.h>
#include <math.h>
#include <vector>
using namespace std;

// ---------- OOP CLASS ----------
class TrafficLight {
public:
    int state;
    vector<int> states; // STL

    TrafficLight() {
        state = 0;
        states = {0,1,2}; // Red, Yellow, Green
    }

    void next() {
        state = (state + 1) % states.size();
    }
};

TrafficLight light; // object

// ---------- DRAW FUNCTIONS ----------
void circle(float x, float y) {
    glBegin(GL_POLYGON);
    for(int i = 0; i < 50; i++) {
        float a = 2 * 3.14 * i / 50;
        glVertex2f(x + 0.15 * cos(a), y + 0.15 * sin(a));
    }
    glEnd();
}

void box() {
    glColor3f(0.2, 0.2, 0.2);
    glBegin(GL_POLYGON);
        glVertex2f(-0.4, 0.8);
        glVertex2f(0.4, 0.8);
        glVertex2f(0.4, -0.8);
        glVertex2f(-0.4, -0.8);
    glEnd();
}

// ---------- DISPLAY ----------
void display() {
    glClear(GL_COLOR_BUFFER_BIT);

    box();

    // RED
    if(light.state == 0) glColor3f(1,0,0);
    else glColor3f(0.3,0,0);
    circle(0, 0.5);

    // YELLOW
    if(light.state == 1) glColor3f(1,1,0);
    else glColor3f(0.3,0.3,0);
    circle(0, 0);

    // GREEN
    if(light.state == 2) glColor3f(0,1,0);
    else glColor3f(0,0.3,0);
    circle(0, -0.5);

    glFlush();
}

// ---------- TIMER (5 sec) ----------
void change(int) {
    light.next(); // OOP function
    glutPostRedisplay();
    glutTimerFunc(5000, change, 0); // 5 seconds
}

// ---------- MAIN ----------
int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutCreateWindow("Traffic Light");

    glClearColor(0,0,0,1);

    glutDisplayFunc(display);
    glutTimerFunc(0, change, 0);

    glutMainLoop();
}