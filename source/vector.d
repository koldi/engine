import BDD;

struct Vector {
protected:
    float _x = 0.0f;
    float _y = 0.0f;
    float _z = 0.0f;
public:
    float GetX() const {
        return _x;
    }

    float GetY() const {
        return _y;
    }

    float GetZ() const {
        return _z;
    }
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

unittest {
    describe("vector#constructor",
		it("default should initialize for zero vector", delegate() {
            Vector v;
            v.GetX().shouldEqual(0.0f);
            v.GetY().shouldEqual(0.0f);
            v.GetZ().shouldEqual(0.0f);
		}),
        it("should initialize correctly", delegate() {
            Vector v = Vector(1,2,3);
            v.GetX().shouldEqual(1.0f);
            v.GetY().shouldEqual(2.0f);
            v.GetZ().shouldEqual(3.0f);
		}),
        it(" for 2d vector - z should be 0", delegate(){
            auto v = Vector(1,2);
            v.GetX().shouldEqual(1.0f);
            v.GetY().shouldEqual(2.0f);
            v.GetZ().shouldEqual(0.0f);
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
            v.Magnitude().shouldEqual(0.0f);
        }),
        it("should be correct for non-zero vector", delegate(){
            Vector v = Vector(1,2,3);
            v.Magnitude().shouldBeGreater(3.74f);
            v.Magnitude().shouldBeLess(3.75f);
        })
    );
    describe("vector#reverse",
        it("should be reversed itself", delegate(){
            Vector v = Vector(1,2,3);
            Vector reversed = Vector(-1,-2,-3);
            v.Reverse();
            v.shouldEqual(reversed);
        }),
        it("two times is the original", delegate(){
            Vector v = Vector(1,2,3);
            auto orig = v;
            v.Reverse();
            v.shouldNotEqual(orig);
            v.Reverse();
            v.shouldEqual(orig);
        })
    );
    describe("vector#normalize ",
        it("should be correct", delegate(){
            Vector v = Vector(1,2,3);
            v.Normalize();
            v.GetX().shouldBeGreater(0.26f);
            v.GetX().shouldBeLess(0.27f);
            v.GetY().shouldBeGreater(0.53f);
            v.GetY().shouldBeLess(0.54f);
            v.GetZ().shouldBeGreater(0.80f);
            v.GetZ().shouldBeLess(0.81f);
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
}