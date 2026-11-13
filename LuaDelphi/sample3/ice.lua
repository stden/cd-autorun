function Ice(T, L)
  if (L > 5) then
    Ice(T, L/2) T:L(90)
    Ice(T, L/3) T:R(180)
    Ice(T, L/3) T:L(90)
    Ice(T, L/2)
  else
    T:F(L)
  end
end

T = TTortoise{X=0, Y=0, Angle=0}

Clear()
for I = 0,3 do
  Ice(T, 200)
  T:L(90)
end

T:Free()
