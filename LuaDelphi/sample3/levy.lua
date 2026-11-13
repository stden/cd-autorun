function Levy(T, L)
  if (L > 5) then
    T:L(45) Levy(T, L/math.sqrt(2))
    T:R(90) Levy(T, L/math.sqrt(2))
    T:L(45)
  else
    T:F(L)
  end
end

T = TTortoise{X=0, Y=0, Angle=0}

Clear()
Levy(T, 200)

T:Free()