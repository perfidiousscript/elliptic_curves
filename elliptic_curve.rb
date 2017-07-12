load 'modular_arithmetic.rb'

class EllipticCurve
	include ModularArithmetic
	attr_accessor :equation, :modulo

	def initialize(a,b, modulo = nil)
		if 4*(a**3)+27*(b**2) == 0
			puts "Invalid! Equation contains singularity!"
		else
			@equation = {a: a, b: b}
			@modulo = modulo
		end
	end

	def evaluate(x)
		points = find_points(x)
		point = Point.new(x,points[:positive])
	end

	def evaluate_negative(x)
		points = find_points(x)
		point = Point.new(x,points[:negative])
	end

	def add_points(a,b)
		r = {}
		if a == b
			slope = (3*a.y**2 + @equation[:a]) / (2 * a.y)
			r[:x] = slope**2 - (2 * a.x)
			r[:y] = ( slope * ( a.x - r[:x]) ) - a.y
		else
			slope = (a.y-b.y)/(a.x-b.x)
			r[:x] = slope**2 - a.x - b.x
			r[:y] = slope * (a.x - r[:x] ) - a.y
		end
		r
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

	def point_on_curve?(point)
		left = point.y ** 2
		right = ( point.x ** 3 ) + ( @equation[:a] * point.x ) + @equation[:b]
		(left - right) < 0.01 ? true : {left: left, right: right}
	end

end


class Point
	attr_accessor :x, :y

	def initialize(x,y)
		@x = x
		@y = y
	end
end
