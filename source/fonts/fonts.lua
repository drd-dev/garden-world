local pd <const> = playdate
local gfx <const> = pd.graphics

FONT = {
  MiniMono = gfx.font.new("fonts/Mini Mono/Mini Mono"),
  MiniSans = gfx.font.new("fonts/Mini Sans/Mini Sans"),
  NanoSans = gfx.font.newFamily({
    [gfx.font.kVariantNormal] = "fonts/Nano Sans/Nano Sans",
    [gfx.font.kVariantBold] = "fonts/Nano Sans/Nano Sans",
  })
};



-- GLYPHS

-- Ⓐ - A Button
-- Ⓑ - B Button
-- ❤ - Heart
-- ↑ - Up D-pad
-- ↓ - Down D-pad
-- ← - Left D-pad
-- → - Right D-pad
-- ❖ - Gear
-- ❢ Shine
-- ❥ Bullet
-- ✚ Amulet
-- $ coin
