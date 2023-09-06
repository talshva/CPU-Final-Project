import PySimpleGUI as sg
import time
import serial as ser

def init_uart():
    global s
    s = ser.Serial('COM16', baudrate=115200, bytesize=ser.EIGHTBITS,
                   parity=ser.PARITY_NONE, stopbits=ser.STOPBITS_ONE,
                   # write_timeout=1,
                   timeout=1)  # timeout of 1 sec so that the read and write operations are blocking,
    # after the timeout the program continues
    # clear buffers
    s.reset_input_buffer()
    s.reset_output_buffer()


def send_command(char):
    global s
    s.write(bytes(char, 'ascii'))
    time.sleep(0.05)  # delay for accurate read/write operations on both ends


def receive_data():
    chr = b''
    while chr[-1:] != b'\n':
        chr += s.read(1)
        if chr == b'':
            break

    return chr.decode('ascii')


def receive_char():
    data = b''
    time.sleep(0.25)  # delay for accurate read/write operations on both ends
    while len(data.decode('ascii')) == 0:
        data = s.read_until(terminator=b'\n')  # read  from the buffer until the terminator is received,
    return data.decode('ascii')


def main():
    global s

    menu_layout = [[sg.Button('', image_filename='Menu Buttons/button1.png',
                              button_color=(sg.theme_background_color(), sg.theme_background_color()), border_width=0,
                              key='Up Counter'),
                    sg.Button('', image_filename='Menu Buttons/button2.png',
                              button_color=(sg.theme_background_color(), sg.theme_background_color()), border_width=0,
                              key='Down Counter')
                    ],
                   [sg.Button('', image_filename='Menu Buttons/button3.png',
                              button_color=(sg.theme_background_color(), sg.theme_background_color()), border_width=0,
                              key='Clear led'),
                    sg.Button('', image_filename='Menu Buttons/button4.png',
                              button_color=(sg.theme_background_color(), sg.theme_background_color()), border_width=0,
                              key='send string')
                    ],
                   [sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED7-', border_width=0),
                    sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED6-', border_width=0),
                    sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED5-', border_width=0),
                    sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED4-', border_width=0),
                    sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED3-', border_width=0),
                    sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED2-', border_width=0),
                    sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED1-', border_width=0),
                    sg.Button('⚪', button_color=('red', '#9AF1FF'), key='-LED0-', border_width=0),
                    sg.Button('SET', button_color=('black', '#9AF1FF'), key='-SET-', border_width=0)
                    ],
                   [sg.Output(key="-OUTPUT-", size=(65, 4), font=('Segoe UI', 10))],
                   [sg.Text("© Tal Shvartzberg & Oren Schor", justification='left', font=('Segoe UI', 8))]
                   ]
    window = sg.Window("Final Project - PC Side Menu", menu_layout, background_color='#9AF1FF',
                       font=('Segoe UI', 14))

    button_states = {'-LED7-': 0, '-LED6-': 0, '-LED5-': 0, '-LED4-': 0, '-LED3-': 0, '-LED2-': 0, '-LED1-': 0,
                     '-LED0-': 0}

    char_value = '00000000'  # Initialize with the default value
    init_uart()
    while True:
        event, values = window.read()
        #       event, values = window.read(timeout=100)
        if event == sg.WIN_CLOSED:  # if user closes window or clicks cancel
            send_command('Q')  # quit
            break
        elif event == 'Clear led':
            send_command('1')
            window['-OUTPUT-'].update(f"Clearing all LEDs")
        elif event == 'Up Counter':
            send_command('2')
            window['-OUTPUT-'].update(f"Counting up from 0x00 on the LEDs")
        elif event == 'Down Counter':
            send_command('3')
            window['-OUTPUT-'].update(f"Counting down from 0xFF on the LEDs")
        elif event == 'send string':
            send_command('4')
            window['-OUTPUT-'].update(f" ")
            window['-OUTPUT-'].Widget.tag_configure("blue_text", foreground="blue")
            window['-OUTPUT-'].Widget.insert("end", "Press KEY1 to receive a lovely message \n", "blue_text")
            while True:
                window['-OUTPUT-'].Widget.tag_configure("red_text", foreground="red", font=('Segoe UI', 20))
                window['-OUTPUT-'].Widget.insert("end", receive_data(), "red_text")
                #    print(receive_data(), end='')
                event, values = window.read(timeout=500)
                window.refresh()
                if event != "__TIMEOUT__":
                    flag = 0
                    break
        elif event in ['-LED7-', '-LED6-', '-LED5-', '-LED4-', '-LED3-', '-LED2-', '-LED1-', '-LED0-']:
            # Get the current text of the button
            current_text = window[event].get_text()
            # Toggle the text between ⚪ and ⚫
            new_text = '⚫' if current_text == '⚪' else '⚪'
            # Update the button's text with the new text
            window[event].update(new_text)
            button_states[event] = 1 if new_text == '⚫' else 0

            # Create the char based on the button states
            char_value = ''.join(str(button_states[key]) for key in
                                 ['-LED7-', '-LED6-', '-LED5-', '-LED4-', '-LED3-', '-LED2-', '-LED1-', '-LED0-'])
            window['-OUTPUT-'].update(f" ")
            print(f'LEDs array value: {char_value}')

        elif event == '-SET-':
            led_int = int(char_value, 2)
            led_chr = chr(led_int)
            send_command(led_chr)
        else:
            print('You entered ', values[0])


    window.close()


if __name__ == '__main__':
    # init_uart()
    # send_command('2')
    main()
