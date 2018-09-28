import BDD;

struct Vector {
protected:
    float _x = 0.0f;
    float _y = 0.0f;
    float _z = 0.0f;
public:
    // 3d vector
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

    float magnitude() {
        import std.math : sqrt;
        return sqrt(_x * _x + _y * _y + _z * _z);
    }

    void normalize() {
        import std.math : fabs;
        const float tolerance = 0.0001;
        auto v = magnitude();
        if (v < tolerance) v = 1;
        _x /= v;
        if (fabs(_x) < tolerance) _x = 0;
        _y /= v;
        if (fabs(_y) < tolerance) _y = 0;
        _z /= v;
        if (fabs(_z) < tolerance) _z = 0;
    }

    void reverse() {
        _x = -_x;
        _y = -_y;
        _z = -_z;
    }

    static float tripleScalarProduct(Vector u, Vector v, Vector w) {
        return (u._x * (v._y * w._z - v._z * w._y)) +
               (u._y * (-v._x * w._z + v._z * w._x)) +
               (u._z * (v._x * w._y - v._y * w._x));
    }

    float getX() const {
        return _x;
    }

    float getY() const {
        return _y;
    }

    float getZ() const {
        return _z;
    }

    auto opBinary(string op)(auto ref const(Vector) rhs)
    if (op == "+" || op == "-") {
        mixin(`return Vector( 
            _x` ~ op ~ `rhs._x,
            _y` ~ op ~ `rhs._y,
            _z` ~ op ~ `rhs._z);`
        );
    }

    ref Vector opOpAssign(string op)(auto ref Vector rhs)
    if (op == "+" || op == "-") {
        mixin(`_x` ~ op ~ `= rhs._x,
            _y` ~ op ~ `= rhs._y,
            _z` ~ op ~ `= rhs._z;`
        );
        return this;
    }

    Vector opBinary(string op : "/")(float scalar) {
        return this * (1.0f/scalar);
    }

    ref Vector opOpAssign(string op : "/")(float scalar) {
        return this *= (1.0f/scalar);
    }

    Vector opBinary(string op : "*")(float scalar) {
        return Vector(_x * scalar, _y * scalar, _z * scalar);
    }

    Vector opBinaryRight(string op : "*")(float scalar) {
        return this * scalar;
    }

    ref Vector opOpAssign(string op : "*")(float scalar) {
        _x *= scalar;
        _y *= scalar;
        _z *= scalar;
        return this;
    }

    Vector opBinary(string op : "^")(auto ref const(Vector) rhs) {
        return Vector(_y*rhs._z - _z*rhs._y,
                      -_x*rhs._z + _z*rhs._x,
                      _x*rhs._y - _y*rhs._x);
    }

    float opBinary(string op : "*")(auto ref const(Vector) rhs) {
        return _x*rhs._x + _y*rhs._y + _z*rhs._z;
    }

    Vector opUnary(string op : "-")() {
        return Vector(-_x, -_y, -_z);
    }
}

unittest {
    describe("vector#constructor",
		it("default should initialize for zero vector", delegate() {
            Vector v;
            v.getX().shouldEqual(0.0f);
            v.getY().shouldEqual(0.0f);
            v.getZ().shouldEqual(0.0f);
		}),
        it("should initialize correctly", delegate() {
            Vector v = Vector(1,2,3);
            v.getX().shouldEqual(1.0f);
            v.getY().shouldEqual(2.0f);
            v.getZ().shouldEqual(3.0f);
		}),
        it(" for 2d vector - z should be 0", delegate(){
            auto v = Vector(1,2);
            v.getX().shouldEqual(1.0f);
            v.getY().shouldEqual(2.0f);
            v.getZ().shouldEqual(0.0f);
        })
	);
    describe("vector#equals to",
        it("itself should equal", delegate(){
            Vector v = Vector(1,2,3);
            v.shouldEqual(v);
        }),
        it("copy should equal", delegate(){
            Vector v = Vector(1,2,3);
            auto v2 = v;
            v.shouldEqual(v2);
        }),
        it("different vector shouldn't equal", delegate(){
            Vector v = Vector(1,2,3);
            Vector v2;
            v.shouldNotEqual(v2);
        })
    );
    describe("vector#magnitude",
        it("should be zero for zero vector", delegate(){
            Vector v;
            v.magnitude().shouldEqual(0.0f);
        }),
        it("should be correct for non-zero vector", delegate(){
            Vector v = Vector(1,2,3);
            v.magnitude().shouldBeGreater(3.74f);
            v.magnitude().shouldBeLess(3.75f);
        })
    );
    describe("vector#reverse",
        it("should be reversed itself", delegate(){
            Vector v = Vector(1,2,3);
            Vector reversed = Vector(-1,-2,-3);
            v.reverse();
            v.shouldEqual(reversed);
        }),
        it("two times is the original", delegate(){
            Vector v = Vector(1,2,3);
            auto orig = v;
            v.reverse();
            v.shouldNotEqual(orig);
            v.reverse();
            v.shouldEqual(orig);
        })
    );
    describe("vector#normalize ",
        it("should be correct", delegate(){
            Vector v = Vector(1,2,3);
            v.normalize();
            v.getX().shouldBeGreater(0.26f);
            v.getX().shouldBeLess(0.27f);
            v.getY().shouldBeGreater(0.53f);
            v.getY().shouldBeLess(0.54f);
            v.getZ().shouldBeGreater(0.80f);
            v.getZ().shouldBeLess(0.81f);
        })
    );
    describe("vector#add ",
        it("two vectors should be correct", delegate(){
            auto v1 = Vector(1,2,3);
            auto v2 = Vector(2,3,4);
            auto expected = Vector(3,5,7);
            auto v3 = v1 + v2;
            v3.shouldEqual(expected);
        }),
        it(" a new vector with += should be correct", delegate(){
            auto v1 = Vector(1,2,3);
            auto v2 = Vector(2,3,4);
            auto expected = Vector(3,5,7);
            v1 += v2;
            v1.shouldEqual(expected);
        })
    );
    describe("vector#subtract ",
        it("two vectors should be correct", delegate(){
            auto v1 = Vector(2,3,4);
            auto v2 = Vector(1,2,3);
            auto expected = Vector(1,1,1);
            auto v3 = v1 - v2;
            v3.shouldEqual(expected);
        }),
        it(" a new vector with -= should be correct", delegate(){
            auto v1 = Vector(2,3,4);
            auto v2 = Vector(1,2,3);
            auto expected = Vector(1,1,1);
            v1 -= v2;
            v1.shouldEqual(expected);
        })
    );
    describe("vector#multiplication ",
        it("with scalar is correct", delegate(){
            auto v = Vector(1,2,3);
            auto expected = Vector(2,4,6);
            auto v2 = v * 2.0f;
            v2.shouldEqual(expected);
        }),
        it("with scalar is correct", delegate(){
            auto v = Vector(1,2,3);
            auto expected = Vector(2,4,6);
            auto v2 = 2.0f * v;
            v2.shouldEqual(expected);
        }),
        it("with scalar *= operator", delegate(){
            auto v = Vector(1,2,3);
            auto expected = Vector(2,4,6);
            v *= 2.0f;
            v.shouldEqual(expected);
        })
    );
    describe("vector#division ",
        it("with scalar is correct", delegate(){
            auto v = Vector(2,4,6);
            auto expected = Vector(1,2,3);
            auto v2 = v / 2.0f;
            v2.shouldEqual(expected);
        }),
        it("with scalar /= operator", delegate(){
            auto v = Vector(2,4,6);
            auto expected = Vector(1,2,3);
            v /= 2.0f;
            v.shouldEqual(expected);
        })
    );
    describe("vector#cross product ",
        it(" with other vector correct", delegate(){
            auto v = Vector(1,2,3);
            auto v2 = Vector(2,4,6);
            auto expected = Vector(0,0,0);
            auto v3 = v ^ v2;
            v3.shouldEqual(expected);
        }),
        it(" not commutative", delegate(){
            auto v = Vector(1,2,3);
            auto v2 = Vector(4,3,12);
            auto v3 = v ^ v2;
            auto v4 = v2 ^ v;
            v3.shouldNotEqual(v4);
        }),
        it(" equals the conjugate", delegate(){
            auto v = Vector(1,2,3);
            auto v2 = Vector(4,3,12);
            auto v3 = v ^ v2;
            auto v4 = v2 ^ v;
            v3.shouldEqual(-v4);
        })
    );
    describe("vector#dot product ",
        it(" with other vector correct", delegate(){
            auto v = Vector(1,2,3);
            auto v2 = Vector(2,4,6);
            auto expected = 28.0f;
            auto v3 = v * v2;
            v3.shouldEqual(expected);
        })
    );
    describe("vector#tripleScalarProduct ",
        it(" correct", delegate(){
            auto v = Vector(1,2,3);
            auto expected = 0.0f;
            auto v3 = Vector.tripleScalarProduct(v,v,v);
            v3.shouldEqual(expected);
        })
    );
}