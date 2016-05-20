require 'class'
require 'nn'
require 'optim'
require 'math'

-- Alexnet as baseline 8 conv layers 3 dense layers
-- Old I know...

cnn = class(function(a)
   a.name = name
   a.model = cnn:build_model()
end)

function cnn:build_model()
  local model = nn.Sequential()
  -- nn.SpatialConvolution(nInputPlane, nOutputPlane, kW, kH, [dW], [dH], [padW], [padH])

  -- Output size: nOutputPlane x oheight x owidth

  model:add(nn.SpatialConvolution(3, 3, 4, 4, 1, 1))
  model:add(nn.ReLU())
  model:add(nn.SpatialMaxPooling(4, 4))
  owidth  = math.floor((480 + 2 - 4) / 1 + 1)
  oheight = math.floor((640 + 2 - 4) / 1 + 1)
  --[[

  model:add(nn.SpatialConvolution(3, 3, 4, 4, 1, 1))
  model:add(nn.ReLU())
  model:add(nn.SpatialMaxPooling(3, 3))

  model:add(nn.SpatialConvolution(3, 3, 4, 4, 1, 1))
  model:add(nn.ReLU())
  model:add(nn.SpatialMaxPooling(3, 3))
  --]]

  model:add(nn.View(3*119*159))
  model:add(nn.Linear(3*119*159, 200))
  model:add(nn.Dropout(.5))
  model:add(nn.Linear(200, 200))
  model:add(nn.Dropout(.5))
  model:add(nn.Linear(200, 200))
  model:add(nn.Dropout(.5))
  model:add(nn.SoftMax())

  --[[
  model:add(nn.View(32*))
  -- classifier:add(nn.Dropout(0.5))
  model:add(nn.Linear(256*6*6, 409))
  model:add(nn.Threshold(0, 1e-6))
  -- classifier:add(nn.Dropout(0.5))
  model:add(nn.Linear(4096, 4096))
  model:add(nn.Threshold(0, 1e-6))
  --]]
  return model
end

function cnn:test()

end

function cnn:train(epochs, mb_generator)
  local params, gradParams = self.model:getParameters()
  local criterion = nn.CrossEntropyCriterion()
  local optimState = {learningRate=0.01}

  for epoch = 1, epochs do
    -- local function we give to optim
    -- it takes current weights as input, and outputs the loss
    -- and the gradient of the loss with respect to the weights
    -- gradParams is calculated implicitly by calling 'backward',
    -- because the model's weight and bias gradient tensors
    -- are simply views onto gradParams
    print('Epoch: ' .. epoch)
    batch_inputs, batch_labels = mb_generator:next()

    local function feval(params)
      gradParams:zero()

      local outputs = self.model:forward(batch_inputs)
      local loss = criterion:forward(outputs, batch_labels)
      local dloss_doutput = criterion:backward(outputs, batch_labels)

      self.model:backward(batch_inputs, dloss_doutput)

      return loss, gradParams
    end

    optim.sgd(feval, params, optimState)

  end


end
