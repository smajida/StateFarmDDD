require 'class'
require 'nn'
require 'optim'


-- Alexnet as baseline 8 conv layers 3 dense layers
-- Old I know...

cnn = class(function(a)
   a.name = name
   a.model = cnn:build_model()
end)

function cnn:build_model()
  local model = nn.Sequential()
  
  model:add(nn.SpatialConvolution(3, 3, 4, 4, 1, 1, 1, 1))
  model:add(nn.ReLU())
  model:add(nn.SpatialMaxPooling(3, 3))
  
  model:add(nn.SpatialConvolution(3, 3, 4, 4, 1, 1, 1, 1))
  model:add(nn.ReLU())
  model:add(nn.SpatialMaxPooling(3, 3))
  
  model:add(nn.SpatialConvolution(3, 3, 4, 4, 1, 1, 1, 1))
  model:add(nn.ReLU())
  model:add(nn.SpatialMaxPooling(3, 3))
  
  model:add(nn.View(3 * 3 * 3))
  model:add(nn.Linear(3 * 3 * 3, 200))
  model:add(nn.Dropout(.5))
  model:add(nn.Linear(200, 200))
  model:add(nn.Dropout(.5))
  model:add(nn.Linear(200, 200))
  model:add(nn.Dropout(.5))
  model:add(nn.SoftMax(200, 10))
  
  return model
end

function cnn:test()

end

function cnn:train(epochs)

  for epoch = 1, epochs do
    -- local function we give to optim
    -- it takes current weights as input, and outputs the loss
    -- and the gradient of the loss with respect to the weights
    -- gradParams is calculated implicitly by calling 'backward',
    -- because the model's weight and bias gradient tensors
    -- are simply views onto gradParams
    local function feval(params)
      gradParams:zero()

      local outputs = model:forward(batchInputs)
      local loss = criterion:forward(outputs, batchLabels)
      local dloss_doutput = criterion:backward(outputs, batchLabels)

      model:backward(batchInputs, dloss_doutput)

      return loss,gradParams
    end

    optim.sgd(feval, params, optimState)

  end


end