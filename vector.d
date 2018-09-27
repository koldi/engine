
class Vector {
protected:
    float _x,_y,_z;
public:
    // 3d vector
    this() {
        _x = float.init;
        _y = float.init;
        _z = float.init;
    }
    this(float x, float y, float z) {
        _x = x;
        _y = y;
        _z = z;
    }
    // 2d vector
    this(float x, float y) {
        _x = x;
        _y = y;
        _z = 0.0;
    }

    float Magnitude() {
        import std.math : sqrt;
        return sqrt(_x * _x + _y * _y + _z * _z);
    }

    void Normalize() {
        import std.math : fabs;
        const float tolerance = 0.0001;
        auto v = Magnitude();
        if (v < tolerance) v = 1;
        _x /= v;
        if (fabs(_x) < tolerance) _x = 0;
        _y /= v;
        if (fabs(_y) < tolerance) _y = 0;
        _z /= v;
        if (fabs(_z) < tolerance) _z = 0;
    }

    void Reverse() {
        _x = -_x;
        _y = -_y;
        _z = -_z;
    }

    Vector opBinary(string op)(auto ref const(Vector) rhs)
    if (op == "+" || op == "-") {
        mixin(`return Vector( 
            _x` ~ op ~ `rhs._x,
            _y` ~ op ~ `rhs._y,
            _z` ~ op ~ `rhs._z);`
        );
    }

    Vector opBinary(string op : "/")(float scalar) {
        return this * (1.0f/scalar);
    }

    Vector opBinary(string op : "*")(float scalar) {
        return Vector(_x * scalar, _y * scalar, _z * scalar);
    }

    Vector opBinaryRight(string op : "*")(float scalar) {
        return this * scalar;
    }

    Vector opUnary(string op : "-")() {
        return Vector(-_x, -_y, -_z);
    }
}

void main() {

}