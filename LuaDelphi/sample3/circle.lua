T = TTortoise{X=0, Y=0, Angle=0}

Clear()
for I = 0,360-1 do
  T:F(2)
  T:L(1)
end

T:Free()
