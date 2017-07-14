load 'modular_arithmetic.rb'

# A toy/learning library for generating and elliptic curve. (Not for acutal crypro)
# Based off of https://www.johannes-bauer.com/compsci/ecc/
# Reqires the ruby modular arithmetic library which can be found
# at https://gist.github.com/jingoro/2388745

class EllipticCurve
	include ModularArithmetic
	attr_accessor :equation, :modulo

	def initialize(a,b, modulo = nil)
		if discriminant(a,b) == 0
			puts "Invalid! Equation contains singularity!"
		else
			@equation = {a: a, b: b}
			@modulo = modulo
		end
	end

	def discriminant(a = @equation[:a], b = @equation[:b])
		-16 * ( (4 * a ** 3) + (27 * b ** 2))
	end

	def evaluate(x)
		points = find_points(x)
		point = Point.new(x,points[:positive])
	end

	def evaluate_negative(x)
		points = find_points(x)
		point = Point.new(x,points[:negative])
	end

	def add_points(a,b, mod = nil)
		r = Point.new()
		if a == b
			slope = (3*a.y**2 + @equation[:a]) / (2 * a.y)
			r.x = slope**2 - (2 * a.x)
			r.y = ( slope * ( a.x - r.x) ) - a.y
		else
			slope = (a.y-b.y)/(a.x-b.x)
			r.x = slope**2 - a.x - b.x
			r.y = slope * (a.x - r.x ) - a.y
		end
		mod.nil? ? r : ModuloPoint.new(r,mod)
	end

	def double_point(a)
		add_points(a,a)
	end

	def find_points(x)
		y = {}
		y_square = ( x**3 ) + ( @equation[:a] * x ) + @equation[:b]
		y[:positive] = Math.sqrt(y_square)
		y[:negative] = 0 - y[:positive]
		y
	end

	def scalar_multiply(a,point)
		unless ((a.class == ( Fixnum || Float)) && point.class == Point)
			return "Must take a scalar and a point: (scalar,Point)"
		end

	end

	def point_on_curve?(point, strict=false)
		left = point.y ** 2
		right = ( point.x ** 3 ) + ( @equation[:a] * point.x ) + @equation[:b]
		strict ? left == right : (left - right) < 0.01
	end

end


class Point
	attr_accessor :x, :y

	def initialize(x,y)
		@x = x
		@y = y
	end
end

class ModuloPoint
	attr_accessor :x, :y, :mod

	def initialize(point,mod)
		@x = point.x % mod
		@y = point.y % mod
		@mod = mod
	end
end
