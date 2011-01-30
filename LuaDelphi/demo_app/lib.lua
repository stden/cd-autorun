function add(a, b)
	return a + b
end

function factorial(n)
	local f = 1
	local i = 1
	n = tonumber(n)
	repeat 
		f = f * i
		i = i + 1
		print(f)
	until i > n
	return f
end

function sum(...)
	local s = 0
	for i = 1, table.getn(arg) do
		print(arg[i])
		s = s + tonumber(arg[i])
	end
	return s
end

function multret()
	return 1, 2, 3
end

function dir(path)
	return Dir.entries(path)
end
