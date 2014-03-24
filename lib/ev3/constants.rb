module EV3
  module ParameterFormat
    SHORT = 0x00
    LONG = 0x80
  end

  module ParameterType
    CONSTANT = 0x00
    VARIABLE = 0x40
  end

  module ShortSign
    POSITIVE = 0x00
    NEGATIVE = 0x20
  end

  module ConstantParameterType
    VALUE = 0x00
    LABEL = 0x20
  end

  module VariableScope
    LOCAL = 0x00
    GLOBAL = 0x20
  end

  module VariableType
    VALUE = 0x00
    HANDLE = 0x10
  end

  module FollowType
    ONE_BYTE = 0x01
    TWO_BYTES = 0x02
    FOUR_BYTES = 0x03
    TERMINATED_STRING = 0x00
    TERMINATED_STRING2 = 0x04
  end

  module ProgramSlots
    # Program slot reserved for executing the user interface
    GUI = 0
    # Program slot used to execute user projects, apps and tools
    USER = 1
    # Program slot used for direct commands coming from c_com
    CMD = 2
    # Program slot used for direct commands coming from c_ui
    TERM = 3
    # Program slot used to run the debug ui
    DEBUG = 4
    # ONLY VALID IN opPROGRAM_STOP
    CURRENT = -1
  end

  module DaisyChainLayer
    # The EV3
    EV3 = 0
    # First EV3 in the Daisychain
    FIRST = 1
    # Second EV3 in the Daisychain
    SECOND = 2
    # Third EV3 in the Daisychain
    THIRD = 3
  end

  module CommandType
    WITHOUT_REPLY = 0x80

    # Direct command
    DIRECT_COMMAND = 0x00
    DIRECT_COMMAND_NO_REPLY = 0x80 | WITHOUT_REPLY
    # System command.
    SYSTEM_COMMAND = 0x01
    SYSTEM_COMMAND_NO_REPLY = 0x80 | WITHOUT_REPLY
    # Direct command reply.
    DIRECT_REPLY = 0x02
    # System command reply.
    SYSTEM_REPLY = 0x03
    # Direct reply with error.
    DIRECT_REPLY_WITH_ERROR = 0x04
    # System reply with error.
    SYSTEM_REPLY_WITH_ERROR = 0x05
  end

  module SystemCommand
    NONE = 0x00
    BEGIN_DOWNLOAD = 0x92
    CONTINUE_DOWNLOAD = 0x93
    BEGIN_UPLOAD = 0x94
    CONTINUE_UPLOAD = 0x95
    BEGIN_GET_FILE = 0x96
    CONTINUE_GET_FILE = 0x97
    CLOSE_FILE_HANDLE = 0x98
    LIST_FILES = 0x99
    CONTINUE_LIST_FILES = 0x9a
    CREATE_DIR = 0x9b
    DELETE_FILE = 0x9c
    LIST_OPEN_HANDLES = 0x9d
    WRITE_MAILBOX = 0x9e
    BLUETOOTH_PIN = 0x9f
    ENTER_FIRMWARE_UPDATE = 0xa0
  end

  module ByteCodes
    # VM
    PROGRAM_STOP = 0x02
    PROGRAM_START = 0x03
    # Move
    INIT_BYTES = 0x2F
    # VM
    INFO = 0x7C
    STRING = 0x7D
    MEMORY_WRITE = 0x7E
    MEMORY_READ = 0x7F
    # Sound
    SOUND = 0x94
    SOUND_TEST = 0x95
    SOUND_READY = 0x96
    # Input
    INPUT_SAMPLE = 0x97
    INPUT_DEVICE_LIST = 0x98
    INPUT_DEVICE = 0x99
    INPUT_READ = 0x9a
    INPUT_TEST = 0x9b
    INPUT_READY = 0x9c
    INPUT_READ_SI = 0x9d
    INPUT_READ_EXT = 0x9e
    INPUT_WRITE = 0x9f
    # output
    OUTPUT_GET_TYPE = 0xa0
    OUTPUT_SET_TYPE = 0xa1
    OUTPUT_RESET = 0xa2
    OUTPUT_STOP = 0xA3
    OUTPUT_POWER = 0xA4
    OUTPUT_SPEED = 0xA5
    OUTPUT_START = 0xA6
    OUTPUT_POLARITY = 0xA7
    OUTPUT_READ = 0xA8
    OUTPUT_TEST = 0xA9
    OUTPUT_READY = 0xAA
    OUTPUT_POSITION = 0xAB
    OUTPUT_STEP_POWER = 0xAC
    OUTPUT_TIME_POWER = 0xAD
    OUTPUT_STEP_SPEED = 0xAE
    OUTPUT_TIME_SPEED = 0xAF
    OUTPUT_STEP_SYNC = 0xB0
    OUTPUT_TIME_SYNC = 0xB1
    OUTPUT_CLR_COUNT = 0xB2
    OUTPUT_GET_COUNT = 0xB3
    # Memory
    FILE = 0xC0
    ARRAY = 0xc1
    ARRAY_WRITE = 0xc2
    ARRAY_READ = 0xc3
    ARRAY_APPEND = 0xc4
    MEMORY_USAGE = 0xc5
    FILE_NAME = 0xc6
    # Mailbox
    MAILBOX_OPEN = 0xD8
    MAILBOX_WRITE = 0xD9
    MAILBOX_READ = 0xDA
    MAILBOX_TEST = 0xDB
    MAILBOX_READY = 0xDC
    MAILBOX_CLOSE = 0xDD
  end

  module SoundSubCodes
    BREAK = 0
    TONE = 1
    PLAY = 2
    REPEAT = 3
    SERVICE = 4
  end

  module InputSubCodes
    GET_FORMAT = 2
    CAL_MIN_MAX = 3
    CAL_DEFAULT = 4
    GET_TYPE_MODE = 5
    GET_SYMBOL = 6
    CAL_MIN = 7
    CAL_MAX = 8
    SETUP = 9
    CLEAR_ALL = 10
    GET_RAW = 11
    GET_CONNECTION = 12
    STOP_ALL = 13
    GET_NAME = 21
    GET_MODE_NAME = 22
    SET_RAW = 23
    GET_FIGURES = 24
    GET_CHANGES = 25
    CLR_CHANGES = 26
    READY_PCT = 27
    READY_RAW = 28
    READY_SI = 29
    GET_MIN_MAX = 30
    GET_BUMPS = 31
  end

  module FileSubCodes
    OPEN_APPEND = 0
    OPEN_READ = 1
    OPEN_WRITE = 2
    READ_VALUE = 3
    WRITE_VALUE = 4
    READ_TEXT = 5
    WRITE_TEXT = 6
    CLOSE = 7
    LOAD_IMAGE = 8
    GET_HANDLE = 9
    LOAD_PICTURE = 10
    GET_POOL = 11
    UNLOAD = 12
    GET_FOLDERS = 13
    GET_ICON = 14
    GET_SUBFOLDER_NAME = 15
    WRITE_LOG = 16
    C_LOSE_LOG = 17
    GET_IMAGE = 18
    GET_ITEM = 19
    GET_CACHE_FILES = 20
    PUT_CACHE_FILE = 21
    GET_CACHE_FILE = 22
    DEL_CACHE_FILE = 23
    DEL_SUBFOLDER = 24
    GET_LOG_NAME = 25
    GET_CACHE_NAME = 26
    OPEN_LOG = 27
    READ_BYTES = 28
    WRITE_BYTES = 29
    REMOVE = 30
    MOVE = 31
  end

  module MemorySubCodes
    DELETE = 0
    CREATE8 = 1
    CREATE16 = 2
    CREATE32 = 3
    CREATE_TEF = 4
    RESIZE = 5
    FILL = 6
    COPY = 7
    INIT8 = 8
    INIT16 = 9
    INIT32 = 10
    INIT_F = 11
    SIZE = 12
  end
end