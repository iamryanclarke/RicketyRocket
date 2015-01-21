-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
	local physics = { data =
	{ 
		
		["earth"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -459, -53  ,  -453, 81  ,  -567, 27  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -485, 203  ,  -433, 157  ,  -383, 253  ,  -461, 291  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   395, 369  ,  423, 233  ,  453, 283  ,  469, 363  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -301, 355  ,  -141, 437  ,  -283, 461  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -255, -479  ,  -189, -423  ,  -373, -269  ,  -421, -329  ,  -399, -437  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   361, -331  ,  319, -389  ,  467, -451  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   319, -389  ,  361, -331  ,  467, -173  ,  195, -413  ,  263, -431  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -141, 437  ,  -59, 453  ,  -141, 635  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   97, -449  ,  -119, -445  ,  -145, -547  ,  135, -547  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   499, 125  ,  423, 233  ,  451, -25  ,  503, -7  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   129, 437  ,  451, -25  ,  423, 233  ,  337, 391  ,  311, 419  ,  167, 485  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -395, -249  ,  -423, -191  ,  -585, -335  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   337, 391  ,  423, 233  ,  395, 369  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -383, 253  ,  -433, 157  ,  -453, 81  ,  -459, -53  ,  -447, -123  ,  -59, 453  ,  -141, 437  ,  -301, 355  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -373, -269  ,  -189, -423  ,  -119, -445  ,  467, -173  ,  431, -149  ,  -447, -123  ,  -423, -191  ,  -395, -249  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   195, -413  ,  467, -173  ,  -119, -445  ,  97, -449  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 2, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -3, 455  ,  -59, 453  ,  -447, -123  ,  431, -149  ,  451, -25  ,  129, 437  }
                    }
                    
                    
                    
        }
		
		, 
        ["hero"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "", density = 10, friction = 0, bounce = 1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   11, -39.5  ,  18, -26.5  ,  22, -4.5  ,  -20, 11.5  ,  -22, -5.5  ,  -18, -26.5  ,  -11, -39.5  ,  0, -51.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 0, bounce = 1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   21, 11.5  ,  -20, 11.5  ,  22, -4.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 0, bounce = 1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   29, 31.5  ,  1, 35.5  ,  -11, 35.5  ,  -28, 33.5  ,  -26, 16.5  ,  -20, 11.5  ,  21, 11.5  ,  27, 16.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 0, bounce = 1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -28, 33.5  ,  -11, 35.5  ,  -23, 49.5  ,  -26, 49.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 0, bounce = 1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   23, 49.5  ,  12, 35.5  ,  29, 31.5  ,  25, 49.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 0, bounce = 1, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   1, 35.5  ,  29, 31.5  ,  12, 35.5  }
                    }
                    
                    
                    
                    
                    
		}
		
	} }

        -- apply scale factor
        local s = scale or 1.0
        for bi,body in pairs(physics.data) do
                for fi,fixture in ipairs(body) do
                    if(fixture.shape) then
                        for ci,coordinate in ipairs(fixture.shape) do
                            fixture.shape[ci] = s * coordinate
                        end
                    else
                        fixture.radius = s * fixture.radius
                    end
                end
        end
	
	function physics:get(name)
		return unpack(self.data[name])
	end

	function physics:getFixtureId(name, index)
                return self.data[name][index].pe_fixture_id
	end
	
	return physics;
end

return M
