function Circle(OX, OY, L, C)
  T = TTortoise{X=OX, Y=OY, Angle=0}
  T.Color = C

  for I = 0,360/10-1 do
    T:F(L * 10)
    T:L(10)
  end
  T:Free()
end

Clear()
for I = 0,10 do
  X = 100 * (2 * math.random() - 1)
  Y = 100 * (2 * math.random() - 1)
  L = 2 * math.random()
  C = math.random(0, 16777215)
  Circle(X, Y, L, C)
end