require 'dino'

board = Dino::Board.new(Dino::TxRx.new)

led4 = Dino::Components::Led.new(pin: 4, board: board)
led3 = Dino::Components::Led.new(pin: 3, board: board)
led2 = Dino::Components::Led.new(pin: 2, board: board)
thermometer = Dino::Components::Sensor.new(pin: 'A0', board: board)

baseline_temp = 23

thermometer.when_data_received do |data|
  voltage = (data.to_f / 1024.0) * 5
  temperature = (voltage - 0.5) * 100
  # temp_f = (temp_c * 1.8) + 32

  puts "Temperature: #{temperature.round(2)} C"

  if temperature < baseline_temp + 2
    led2.send(:off)
    led3.send(:off)
    led4.send(:off)
  elsif temperature > baseline_temp + 2 && temperature < baseline_temp + 4
    led2.send(:on)
    led3.send(:off)
    led4.send(:off)
  elsif temperature > baseline_temp + 4 && temperature < baseline_temp + 6
    led2.send(:on)
    led3.send(:on)
    led4.send(:off)
  elsif temperature > baseline_temp + 6
    led2.send(:on)
    led3.send(:on)
    led4.send(:on)
  end

  sleep 1
end

sleep 5
