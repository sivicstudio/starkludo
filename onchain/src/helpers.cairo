use starknet::{ContractAddress, contract_address_const};

pub fn get_safe_positions() -> Array<u32> {
    array![
        1,
        9,
        14,
        22,
        27,
        35,
        40,
        48,
        1001,
        1002,
        1003,
        1004,
        1005,
        2001,
        2002,
        2003,
        2004,
        2005,
        3001,
        3002,
        3003,
        3004,
        3005,
        4001,
        4002,
        4003,
        4004,
        4005,
    ]
}

pub fn get_markers() -> Array<felt252> {
    array![
        'r0',
        'r1',
        'r2',
        'r3',
        'g0',
        'g1',
        'g2',
        'g3',
        'y0',
        'y1',
        'y2',
        'y3',
        'b0',
        'b1',
        'b2',
        'b3',
    ]
}

pub fn find_index(value: felt252, a: Array<felt252>) -> usize {
    let mut i = 0;
    loop {
        if (i >= a.len()) {
            break 0;
        } else if (a.at(i) == @value) {
            break i;
        }
        i += 1;
    }
}

pub fn get_start_points() -> Array<u32> {
    array![0, 13, 26, 39]
}

pub fn board_to_pos(arr: Array<u32>) -> Array<u32> {
    let mut new_arr: Array<u32> = ArrayTrait::new();
    let mut i: u32 = 0;

    loop {
        if i >= arr.len() {
            break;
        }

        let val = *arr.at(i);
        let color: u32 = i / 4;

        let new_val = if val > 52 {
            51 + (val % 1000)
        } else if val == 0 {
            0
        } else {
            let diff = if val >= *get_start_points().at(color) {
                val - *get_start_points().at(color)
            } else {
                val + 52 - *get_start_points().at(color)
            };

            if diff < 1 {
                diff + 52
            } else {
                diff
            }
        };

        new_arr.append(new_val);
        i += 1;
    };

    new_arr
}

pub fn pos_to_board(arr: Array<u32>) -> Array<u32> {
    let mut new_arr: Array<u32> = ArrayTrait::new();
    let mut i: u32 = 0;

    loop {
        if i >= arr.len() {
            break;
        }

        let val = *arr.at(i);
        let color: u32 = i / 4;

        let new_val = if val > 51 {
            (color + 1) * 1000 + (val % 50) - 1
        } else if val == 0 {
            0
        } else {
            let a = (*get_start_points().at(color) + val) % 52;
            if a == 0 {
                52
            } else {
                a
            }
        };

        new_arr.append(new_val);
        i += 1;
    };

    new_arr
}

pub fn zero_address() -> ContractAddress {
    contract_address_const::<0x0>()
}

pub fn contains(array: Array<u32>, value: u32) -> bool {
    let mut found = false;
    for item in array {
        if item == value {
            found = true;
            break;
        }
    };
    return found;
}

pub fn get_cap_colors() -> Array<felt252> {
    array!['R', 'G', 'Y', 'B']
}

pub fn pos_reducer(data: Array<u32>, active_colors: Array<u8>) -> Array<felt252> {
    let mut game: Array<felt252> = ArrayTrait::new();
    let cap_colors = get_cap_colors();

    let mut active_piece_count: u32 = 0;
    let mut i: u32 = 0;
    loop {
        if i >= data.len() {
            break;
        }

        let d = *data.at(i);

        // Determine the color index based on the current index
        let color_index = i / 4;
        let piece_index = i % 4;

        let mut active_colors_u32: Array<u32> = ArrayTrait::new();
        for color in active_colors.clone() {
            active_colors_u32.append((color).into());
        };

        // Check if the current color is in the active colors
        if contains(active_colors_u32, color_index) {
            let color_id = color_index;

            let color_char = *cap_colors.at(color_id.into());

            let value = if d == 0 {
                let piece_offset = piece_index + 1;
                color_char * 100 + piece_offset.into()
            } else if d > 1000 {
                let remainder = d % 1000;
                color_char * 1000 + remainder.into()
            } else {
                d.into()
            };

            game.append(value);

            active_piece_count += 1;
        }
        i += 1;
    };

    game
}
