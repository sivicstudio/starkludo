#[cfg(test)]
mod test_helpers {
    use starkludo::helpers::{
        get_safe_positions, get_markers, get_start_points, find_index, board_to_pos,
        pos_to_board, contains, get_cap_colors, pos_reducer,
    };

    // *******************************************
    //          get_start_points
    // *******************************************

    #[test]
    fn test_get_start_points_returns_successfully() {
        let actual_result = get_start_points();
        let expected_result = array![0, 13, 26, 39];
        assert_eq!(actual_result, expected_result);
    }

    // *******************************************
    //          get_markers
    // *******************************************

    #[test]
    fn test_get_markers_returns_successfully() {
        let actual_result = get_markers();
        let expected_result = array![
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
        ];
        assert_eq!(actual_result, expected_result);
    }

    // *******************************************
    //          get_safe_positions
    // *******************************************

    #[test]
    fn test_get_safe_positions_returns_successfully() {
        let actual_result = get_safe_positions();
        let expected_result = array![
            1, 9, 14, 22, 27, 35, 40, 48,
            1001, 1002, 1003, 1004, 1005,
            2001, 2002, 2003, 2004, 2005,
            3001, 3002, 3003, 3004, 3005,
            4001, 4002, 4003, 4004, 4005
        ];
        assert_eq!(actual_result, expected_result);
    }

    // *******************************************
    //          find_index
    // *******************************************

    #[test]
    fn test_find_index_found() {
        let markers = get_markers();
        // Searching for 'g2' which is at index 6.
        let index = find_index('g2', markers.clone());
        assert_eq!(index, 6, "find_index should return the correct index when found");
    }

    #[test]
    fn test_find_index_not_found() {
        let markers = get_markers();
        // Searching for a value that is not in the array
        let index = find_index('X', markers.clone());
        // According to our logic, if not found, it returns 0.
        // Ensure that if the first element is not 'X', we interpret index 0 as "not found".
        if *markers.at(0) != 'X' {
            assert_eq!(index, 0, "find_index should return 0 if the element is not found");
        }
    }

    // *******************************************
    //          contains
    // *******************************************

    #[test]
    fn test_contains_true() {
        let arr = array![10, 20, 30, 40];
        assert!(contains(arr, 30), "contains should return true when value exists");
    }

    #[test]
    fn test_contains_false() {
        let arr = array![10, 20, 30, 40];
        assert!(!contains(arr, 50), "contains should return false when value does not exist");
    }

    // *******************************************
    //          board_to_pos
    // *******************************************

    #[test]
    fn test_board_to_pos_converts_correctly() {
        // For a single-color scenario (Red).
        // Logic:
        //  - if value == 0 then piece is not placed.
        //  - if value <= 52 then it is a normal move.
        //  - if value > 52 then it indicates a piece in the home stretch,
        //    and the internal pos becomes 51 + (value % 1000).
        let board = array![0, 14, 55, 1003];
        let pos_result = board_to_pos(board);
        let expected = array![
            0,                    // not placed
            14,                   // normal move
            51 + 55,              // home: 51+55 = 106
            51 + (1003 % 1000)     // home: 51+3 = 54
        ];
        assert_eq!(pos_result, expected, "board_to_pos should convert board positions correctly for red pieces");
    }

    #[test]
    fn test_board_to_pos_for_all_colors() {

        // Conversion rules:
        //   If board value == 0 => not placed, so internal pos remains 0.
        //   If board value <= 52 => normal move: pos = board_value - start_point.
        //   If board value > 52  => home stretch: pos = 51 + (board_value % 1000).
        //
        // Given board array:
        let board = array![
            // Red group (start: 0)
            0, 14, 55, 1003,
            // Green group (start: 13)
            0, 20, 60, 1020,
            // Yellow group (start: 26)
            0, 30, 70, 1030,
            // Blue group (start: 39)
            0, 40, 80, 1040
        ];
        let result = board_to_pos(board);
        // Expected conversion:
        // Red:
        //   0      -> 0
        //   14     -> 14 - 0 = 14
        //   55     -> 55 > 52   => 51 + 55 = 106
        //   1003   -> 1003 > 52 => 51 + (1003 % 1000) = 51 + 3 = 54
        // Green:
        //   0      -> 0
        //   20     -> 20 - 13 = 7
        //   60     -> 60 > 52   => 51 + 60 = 111
        //   1020   -> 1020 > 52 => 51 + (1020 % 1000) = 51 + 20 = 71
        // Yellow:
        //   0      -> 0
        //   30     -> 30 - 26 = 4
        //   70     -> 70 > 52   => 51 + 70 = 121
        //   1030   -> 1030 > 52 => 51 + (1030 % 1000) = 51 + 30 = 81
        // Blue:
        //   0      -> 0
        //   40     -> 40 - 39 = 1
        //   80     -> 80 > 52   => 51 + 80 = 131
        //   1040   -> 1040 > 52 => 51 + (1040 % 1000) = 51 + 40 = 91
        let expected = array![
            0, 14, 106, 54,
            0, 7, 111, 71,
            0, 4, 121, 81,
            0, 1, 131, 91
        ];
        assert_eq!(result, expected, "board_to_pos should convert board positions correctly for all colors");
    }

    #[test]
    fn test_board_to_pos_at_threshold() {
        // For board_to_pos: if board value is exactly 52, then for red (start 0):
        // pos = 52 - 0 = 52.
        let board = array![52];
        let pos_result = board_to_pos(board);
        let expected = array![52];
        assert_eq!(pos_result, expected, "board_to_pos should handle threshold value 52 correctly");
    }

    #[test]
    fn test_board_to_pos_not_placed_all_colors() {
        // When all pieces are not placed, board value is 0.
        // Conversion: not placed pieces remain 0 regardless of the color.
        let board = array![
            // Red group
            0, 0, 0, 0,
            // Green group
            0, 0, 0, 0,
            // Yellow group
            0, 0, 0, 0,
            // Blue group
            0, 0, 0, 0
        ];
        let pos_result = board_to_pos(board);
        let expected = array![
            // For every group, not placed becomes 0.
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        ];
        assert_eq!(pos_result, expected, "board_to_pos should handle not placed pieces for all colors");
    }

    #[test]
    fn test_board_to_pos_home_stretch_values() {
        // Test multiple home-stretch values for each color.
        // For a piece in the home stretch, board value > 52.
        // Example for red:
        //   1005 -> 51 + (1005 % 1000)= 51 + 5 = 56.
        // For green (start: 13):
        //   1030 -> 51 + (1030 % 1000)= 51 + 30 = 81.
        let board = array![
            // Red group (start: 0)
            1005,   // should yield 56
            0,
            0,
            0,
            // Green group (start: 13)
            1030,   // should yield 51 + 30 = 81
            0,
            0,
            0,
        ];
        let pos_result = board_to_pos(board);
        let expected = array![
            56,
            0,
            0,
            0,
            81,
            0,
            0,
            0
        ];
        assert_eq!(pos_result, expected, "board_to_pos should correctly handle home stretch conversion");
    }

    // *******************************************
    //          pos_to_board
    // *******************************************

    #[test]
    fn test_pos_to_board_converts_correctly() {
        // Reverse conversion for a single-color scenario (Red).
        let pos_arr = array![0, 14, 106, 54];
        let board_result = pos_to_board(pos_arr);
        let expected = array![
            0,      // not placed
            14,     // normal move
            1005,   // home conversion: For pos=106: (106 - 51) = 55; then board value = 1000 + (55 - 50) = 1005.
            1003    // home conversion: For pos=54: (54 - 51) = 3; then board value = 1000 + 3 = 1003.
        ];
        assert_eq!(board_result, expected, "pos_to_board should convert positions back to board values correctly for red pieces");
    }

    #[test]
    fn test_pos_to_board_for_all_colors() {
        // Inverse conversion: given the internal pos values, we should retrieve the original board values.
        // Using the same groups and start points:
        // Red start 0, Green start 13, Yellow start 26, Blue start 39.
        let pos_arr = array![
            // Red group
            0, 14, 106, 54,
            // Green group
            0, 7, 111, 71,
            // Yellow group
            0, 4, 121, 81,
            // Blue group
            0, 1, 131, 91
        ];
        let result = pos_to_board(pos_arr);
        // Expected board values:
        // Red: 0, 14, 1005, 1003
        // Green: 0, 20, 2010, 2020
        // Yellow: 0, 30, 3020, 4030
        // Blue: 0, 40, 4030, 4040
        let expected = array![
            0, 14, 1005, 1003,
            0, 20, 2010, 2020,
            0, 30, 3020, 3030,
            0, 40, 4030, 4040
        ];
        assert_eq!(result, expected, "pos_to_board should convert positions back to board values correctly for all colors");
    }

    #[test]
    fn test_pos_to_board_at_threshold() {
        // In pos_to_board, if internal pos equals 52, it indicates a piece entering
        // the home stretch. The conversion returns: board = 1000 + (52 - 51) = 1001.
        let pos_arr = array![52];
        let board_result = pos_to_board(pos_arr);
        let expected = array![1001];
        assert_eq!(board_result, expected, "pos_to_board should handle threshold value 52 correctly and return 1001");
    }

    #[test]
    fn test_pos_to_board_not_placed_all_colors() {
        // When internal pos indicates not placed (0 for all groups), conversion back should be 0.
        let pos_arr = array![
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        ];
        let board_result = pos_to_board(pos_arr);
        let expected = array![
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        ];
        assert_eq!(board_result, expected, "pos_to_board should correctly handle not placed pieces for all colors");
    }

    #[test]
    fn test_pos_to_board_home_stretch_values() {
        // Inverse of the above: given internal pos corresponding to home stretch, retrieve board value.
        // For red: 56 should become 1005 since 56 = 51 + 5.
        // For green: 81 should become 1030 since 81 = 51 + 30.
        let pos_arr = array![
            56, 0, 0, 0,
            81, 0, 0, 0
        ];
        let board_result = pos_to_board(pos_arr);
        let expected = array![
            1005, 0, 0, 0,
            2030, 0, 0, 0
        ];
        assert_eq!(board_result, expected, "pos_to_board should correctly handle home stretch conversion");
    }

    // *******************************************
    //          get_cap_colors
    // *******************************************

    #[test]
    fn test_get_cap_colors_returns_successfully() {
        let actual = get_cap_colors();
        let expected = array!['R', 'G', 'Y', 'B'];
        assert_eq!(actual, expected, "get_cap_colors should return correct capital letters");
    }

    // *******************************************
    //          pos_reducer
    // *******************************************

    // Helper to compute expected default token
    fn default_token(color: felt252, piece_index: felt252) -> felt252 {
        if color == 0 {
            return 'R' * 100 + (piece_index + 1);
        } else if color == 1 {
            return 'G' * 100 + (piece_index + 1);
        } else if color == 2 {
            return 'Y' * 100 + (piece_index + 1);
        } else if color == 3 {
            return 'B' * 100 + (piece_index + 1);
        }
        return 0;
    }

    // *******************************************
    // pos_reducer: 16 elements, all four active colors ([0,1,2,3])
    // *******************************************
    #[test]
    fn test_pos_reducer_all_four_active() {
        // Create data for 16 pieces (4 for each color).
        let data: Array<u32> = array![
            0, 0, 0, 0,  // Red
            0, 0, 0, 0,  // Green
            0, 0, 0, 0,  // Yellow
            0, 0, 0, 0   // Blue
        ];
        let active_colors: Array<u8> = array![0, 1, 2, 3];
        let expected: Array<felt252> = array![
            default_token(0, 0), default_token(0, 1), default_token(0, 2), default_token(0, 3),
            default_token(1, 0), default_token(1, 1), default_token(1, 2), default_token(1, 3),
            default_token(2, 0), default_token(2, 1), default_token(2, 2), default_token(2, 3),
            default_token(3, 0), default_token(3, 1), default_token(3, 2), default_token(3, 3)
        ];
        let result = pos_reducer(data, active_colors);
        assert_eq!(result, expected, "pos_reducer should assign default tokens for all four active colors");
    }

    // *******************************************
    // pos_reducer: 8 elements, active_colors = [0, 1]
    // *******************************************
    #[test]
    fn test_pos_reducer_two_active() {
        // Expanded form for 8 pieces (2 groups of 4 pieces each).
        let data: Array<u32> = array![
            0, 0, 0, 0,  // Group 1 -> active_colors[0] (color 0)
            0, 0, 0, 0   // Group 2 -> active_colors[1] (color 1)
        ];
        let active_colors: Array<u8> = array![0, 1];
        let expected: Array<felt252> = array![
            default_token(0, 0), default_token(0, 1), default_token(0, 2), default_token(0, 3),
            default_token(1, 0), default_token(1, 1), default_token(1, 2), default_token(1, 3)
        ];
        let result = pos_reducer(data, active_colors);
        assert_eq!(result, expected, "pos_reducer should assign tokens for active colors [0,1] with 8 pieces");
    }

    // *******************************************
    // pos_reducer: 12 elements, active_colors = [0, 2, 1]
    // *******************************************
    #[test]
    fn test_pos_reducer_three_active() {
        // Expanded form for 12 pieces (3 groups of 4 pieces each).
        let data: Array<u32> = array![
            0, 0, 0, 0,  // Group 1 -> active_colors[0] (color 0)
            0, 0, 0, 0,  // Group 2 -> active_colors[1] (color 1)
            0, 0, 0, 0   // Group 3 -> active_colors[2] (color 2)
        ];
        let active_colors: Array<u8> = array![0, 1, 2];
        let expected: Array<felt252> = array![
            default_token(0, 0), default_token(0, 1), default_token(0, 2), default_token(0, 3),
            default_token(1, 0), default_token(1, 1), default_token(1, 2), default_token(1, 3),
            default_token(2, 0), default_token(2, 1), default_token(2, 2), default_token(2, 3)
        ];
        let result = pos_reducer(data, active_colors);
        assert_eq!(result, expected, "pos_reducer should assign tokens for active colors [0,2,3] when data length is 12");
    }

    // *******************************************
    // pos_reducer: 16 elements with active order [0, 3]
    // *******************************************
    #[test]
    fn test_pos_reducer_active_order_0_and_3() {
        // For 16 pieces, first 4 use active_colors[0] (color 0) and next 4 use active_colors[1] (color 1) 
        let data: Array<u32> = array![
            0, 0, 0, 0,  // Group 1 -> color 0 (Red)
            0, 0, 0, 0,   // Group 2 -> color 1 (Green)
            0, 0, 0, 0,   // Group 3 -> color 2 (Yellow)
            0, 0, 0, 0,   // Group 4 -> color 3 (Blue)
        ];
        let active_colors: Array<u8> = array![0, 3];
        let expected: Array<felt252> = array![
            default_token(0, 0), default_token(0, 1), default_token(0, 2), default_token(0, 3),
            default_token(3, 0), default_token(3, 1), default_token(3, 2), default_token(3, 3)
        ];
        let result = pos_reducer(data, active_colors);
        assert_eq!(result, expected, "pos_reducer should assign tokens for active colors [0,3] for 8 pieces");
    }

    // *******************************************
    // pos_reducer: 12 elements with active order [2, 1]
    // *******************************************
    #[test]
    fn test_pos_reducer_active_order_2_and_1() {
        // For 12 pieces, first 4 use active_colors[0] (color 2) and next 4 use active_colors[1] (color 1).
        let data: Array<u32> = array![
            0, 0, 0, 0,  // Group 1 -> color 0 (Red)
            0, 0, 0, 0,  // Group 2 -> color 1 (Green)
            0, 0, 0, 0   // Group 2 -> color 1 (Green)
        ];
        let active_colors: Array<u8> = array![2, 1];
        let expected: Array<felt252> = array![
            default_token(1, 0), default_token(1, 1), default_token(1, 2), default_token(1, 3),
            default_token(2, 0), default_token(2, 1), default_token(2, 2), default_token(2, 3)
        ];
        let result = pos_reducer(data, active_colors);
        assert_eq!(result, expected, "pos_reducer should assign tokens for active colors [2,1] for 12 pieces");
    }

    // *******************************************
    // pos_reducer: Mixed non-zero values
    // *******************************************
    #[test]
    fn test_pos_reducer_with_nonzero_values() {
        // Test where some values are already set (non-zero and > 1000 condition)
        let data = array![0, 1050, 23, 32, 2005, 2010, 23, 43];
        let active_colors = array![0, 1]; // two active colors: red and green
        let expected = array![
            'R'*100 + 1,
            'R'*1000 + 50,
            23,
            32,
            'G'*1000 + 5,
            'G'*1000 + 10,
            23,
            43
        ];
        let result = pos_reducer(data, active_colors);
        assert_eq!(result, expected, "pos_reducer should convert data using active colors correctly");
    }

}