function draw()

	-- DEFAULT CONFIG

    background(0, 0, 0, 255)
    
    blendMode( NORMAL )

	ellipseMode( CENTER )
	rectMode( CENTER )
	spriteMode( CENTER )
	textMode( CENTER )

	lineCapMode( ROUND )

	noFill() -- fill( red, green, blue, alpha )
	noTint() -- tint( red, green, blue, alpha )
	noStroke() -- stroke( red, green, blue, alpha ) -- strokeWidth( width )

	smooth() -- noSmooth()

	font( "Helvetica-Light" )
	fontSize( 20 )
	textAlign( CENTER )
	textWrapWidth( 0 )

    --
    manager:draw()

end

function touched(touch)
	manager:touched(touch)
end

function keyboard(key)
	manager:keyboard(key)
end

--
function orientationChanged(newOrientation)
end