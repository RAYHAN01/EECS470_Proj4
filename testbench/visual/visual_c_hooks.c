#include "DirectC.h"
#include <curses.h>
#include <stdio.h>
#include <signal.h>
#include <ctype.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/signal.h>
#include <time.h>
#include <string.h>

#define PARENT_READ     readpipe[0]
#define CHILD_WRITE     readpipe[1]
#define CHILD_READ      writepipe[0]
#define PARENT_WRITE    writepipe[1]
#define NUM_ROB			    32
#define NUM_HISTORY     1024
#define READBUFFER_SIZE 2048
#define NUM_ARF         (33 + NUM_ROB)
#define NUM_STAGES      5
#define NOOP_INST       0x47ff041f
#define NUM_REG_GROUPS  8

#define ARF_WIDTH		25
#define ARF_HIGHT		(NUM_ARF + 2)
#define TITLE_WIN_HIGHT 3
#define TIME_WIN_HIGHT	3
#define TIME_WIN_WIDTH  10
#define SIM_TIME_WIN_HIGHT 3
#define SIM_TIME_WIN_WIDTH (TIME_WIN_WIDTH)
#define CLOCK_WIN_HIGHT (TIME_WIN_HIGHT + SIM_TIME_WIN_HIGHT)
#define CLOCK_WIN_WIDTH (ARF_WIDTH - TIME_WIN_WIDTH)
#define PIPE_WIN_HIGHT	6

#define IF_WIN_HIGHT	(num_if_regs + 2)
#define IF_WIN_WIDTH	30
#define IF_ID_WIN_HIGHT	(num_if_id_regs + 2)
#define IF_ID_WIN_WIDTH	(IF_WIN_WIDTH)
#define ID_WIN_HIGHT	(num_id_regs + 2)
#define ID_WIN_WIDTH	(IF_WIN_WIDTH)

#define ID_EX_WIN_HIGHT	(num_id_ex_regs + 2)
#define ID_EX_WIN_WIDTH	30
#define EX_WIN_HIGHT	(num_ex_regs + 2)
#define EX_WIN_WIDTH	(ID_EX_WIN_WIDTH)

#define EX_MEM_WIN_HIGHT	(num_ex_mem_regs + 2)
#define EX_MEM_WIN_WIDTH	30
#define MEM_WIN_HIGHT		(num_mem_regs + 2)
#define MEM_WIN_WIDTH		(EX_MEM_WIN_WIDTH)
#define MEM_WB_WIN_HIGHT	(num_mem_wb_regs + 2)
#define MEM_WB_WIN_WIDTH	(EX_MEM_WIN_WIDTH)

#define RS_WIN_HIGHT	(num_rs_regs + 2)
#define RS_WIN_WIDTH	10

#define RS_TR1_WIN_HIGHT (num_rs_regs + 2)
#define RS_TR1_WIN_WIDTH 10

#define RS_TR2_WIN_HIGHT (num_rs_regs + 2)
#define RS_TR2_WIN_WIDTH 10

#define RS_T1_WIN_HIGHT (num_rs_regs + 2)
#define RS_T1_WIN_WIDTH 10

#define RS_T2_WIN_HIGHT (num_rs_regs + 2)
#define RS_T2_WIN_WIDTH 10

#define RS_BZ_WIN_HIGHT (num_rs_regs + 2)
#define RS_BZ_WIN_WIDTH 10

#define ROB_TN_WIN_HIGHT (num_rob_tn_regs + 2)
#define ROB_TN_WIN_WIDTH 12

#define ROB_TO_WIN_HIGHT (num_rob_to_regs + 2)
#define ROB_TO_WIN_WIDTH 12

#define ROB_RD_WIN_HIGHT (num_rob_rd_regs + 2)
#define ROB_RD_WIN_WIDTH 12

#define ROB_ST_WIN_HIGHT (num_rob_st_regs + 2)
#define ROB_ST_WIN_WIDTH 12

#define FR_WIN_HIGHT (num_fr_regs + 2)
#define FR_WIN_WIDTH 12

#define MAP_WIN_HIGHT (num_map_regs + 2)
#define MAP_WIN_WIDTH 12

#define MAP_RD_WIN_HIGHT (num_map_rd_regs + 2)
#define MAP_RD_WIN_WIDTH 12


#define SQ_WIN_HIGHT (num_sq_regs + 2)
#define SQ_WIN_WIDTH 28

#define SQ_RD_WIN_HIGHT (num_sq_rd_regs + 2)
#define SQ_RD_WIN_WIDTH 30

#define LQ_WIN_HIGHT (num_lq_regs + 2)
#define LQ_WIN_WIDTH 30

#define LQ_ADDR_WIN_HIGHT (num_lq_addr_regs + 2)
#define LQ_ADDR_WIN_WIDTH 28

#define LQ_BUSY_WIN_HIGHT (num_lq_busy_regs + 2)
#define LQ_BUSY_WIN_WIDTH 20

#define LQ_D_WIN_HIGHT (num_lq_dcache_regs + 2)
#define LQ_D_WIN_WIDTH 31

#define DCACHE_WIN_HIGHT (num_dcache_regs + 2)
#define DCACHE_WIN_WIDTH 30

#define DCACHE_CON_WIN_HIGHT (num_dcache_con_regs + 2)
#define DCACHE_CON_WIN_WIDTH 30

#define ICACHE_WIN_HIGHT (num_icache_regs + 2)
#define ICACHE_WIN_WIDTH 30


// random variables/stuff
int fd[2], writepipe[2], readpipe[2];
int stdout_save;
int stdout_open;
void signal_handler_IO (int status);
int wait_flag=0;
char done_state;
char echo_data;
FILE *fp;
FILE *fp2;
int setup_registers = 0;
int stop_time;
int done_time = -1;
char time_wrapped = 0;

// Structs to hold information about each register/signal group
typedef struct win_info {
  int height;
  int width;
  int starty;
  int startx;
  int color;
} win_info_t;

typedef struct reg_group {
  WINDOW *reg_win;
  char ***reg_contents;
  char **reg_names;
  int num_regs;
  win_info_t reg_win_info;
} reg_group_t;

// Window pointers for ncurses windows
WINDOW *title_win;
WINDOW *comment_win;
WINDOW *time_win;
WINDOW *sim_time_win;
WINDOW *instr_win;
WINDOW *clock_win;
WINDOW *pipe_win;
WINDOW *if_win;
WINDOW *if_id_win;
WINDOW *id_win;
WINDOW *id_ex_win;
WINDOW *ex_win;
WINDOW *ex_mem_win;
WINDOW *mem_win;
WINDOW *mem_wb_win;
WINDOW *wb_win;
WINDOW *arf_win;
WINDOW *misc_win;

WINDOW *rs_win;
WINDOW *rs_tr1_win;
WINDOW *rs_t1_win;
WINDOW *rs_tr2_win;
WINDOW *rs_t2_win;
WINDOW *rs_bz_win;

WINDOW *rob_rd_win;
WINDOW *rob_tn_win;
WINDOW *rob_to_win;
WINDOW *rob_st_win;

WINDOW *fr_win;

WINDOW *map_win;
WINDOW *map_rd_win;

WINDOW *sq_win;
WINDOW *sq_rd_win;

WINDOW *lq_win;
WINDOW *lq_addr_win;
WINDOW *lq_busy_win;
WINDOW *lq_dcache_win;

WINDOW *dcache_win;
WINDOW *dcache_con_win;

WINDOW *icache_win;

// arrays for register contents and names
int history_num=0;
int num_misc_regs;
int num_if_regs = 0;
int num_if_id_regs = 0;
int num_id_regs = 0;
int num_id_ex_regs = 0;
int num_ex_regs = 0;
int num_ex_mem_regs = 0;
int num_mem_regs = 0;
int num_mem_wb_regs = 0;
int num_wb_regs = 0;
int num_rs_regs = 0;
int num_rs_tr1_regs = 0;
int num_rs_tr2_regs = 0;
int num_rs_t1_regs = 0;
int num_rs_t2_regs = 0;
int num_rs_bz_regs = 0;
int num_rob_to_regs = 0;
int num_rob_tn_regs = 0;
int num_rob_rd_regs = 0;
int num_rob_st_regs = 0;
int num_fr_regs     = 0;
int num_map_regs     = 0;
int num_map_rd_regs     = 0;
int num_sq_regs     = 0;
int num_sq_rd_regs     = 0;
int num_lq_regs     = 0;
int num_lq_addr_regs     = 0;
int num_lq_busy_regs     = 0;
int num_lq_dcache_regs     = 0;

int num_dcache_regs     = 0;
int num_dcache_con_regs     = 0;

int num_icache_regs     = 0;

char readbuffer[READBUFFER_SIZE];
char **timebuffer;
char **cycles;
char *clocks;
char *resets;

char **inst_contents;
char ***if_contents;
char ***if_id_contents;
char ***id_contents;
char ***id_ex_contents;
char ***ex_contents;
char ***ex_mem_contents;
char ***mem_contents;
char ***mem_wb_contents;
char ***wb_contents;
char ***rs_contents;
char ***rs_tr1_contents;
char ***rs_tr2_contents;
char ***rs_t1_contents;
char ***rs_t2_contents;
char ***rs_bz_contents;
char ***rob_to_contents;
char ***rob_tn_contents;
char ***rob_rd_contents;
char ***rob_st_contents;
char ***fr_contents;
char ***map_contents;
char ***map_rd_contents;
char ***sq_contents;
char ***sq_rd_contents;
char ***lq_contents;
char ***lq_addr_contents;
char ***lq_busy_contents;
char ***lq_dcache_contents;

char ***dcache_contents;
char ***dcache_con_contents;
char ***icache_contents;
char **arf_contents;

char ***misc_contents;
char **if_reg_names;
char **if_id_reg_names;
char **id_reg_names;
char **id_ex_reg_names;
char **ex_reg_names;
char **ex_mem_reg_names;
char **mem_reg_names;
char **mem_wb_reg_names;
char **wb_reg_names;
char **rs_reg_names;
char **rs_tr1_reg_names;
char **rs_tr2_reg_names;
char **rs_t1_reg_names;
char **rs_t2_reg_names;
char **rs_bz_reg_names;
char **rob_tn_reg_names;
char **rob_to_reg_names;
char **rob_rd_reg_names;
char **rob_st_reg_names;
char **fr_reg_names;
char **map_reg_names;
char **map_rd_reg_names;
char **sq_reg_names;
char **sq_rd_reg_names;
char **lq_reg_names;
char **lq_addr_reg_names;
char **lq_busy_reg_names;
char **lq_dcache_reg_names;
char **dcache_reg_names;
char **dcache_con_reg_names;
char **icache_reg_names;
char **misc_reg_names;

char *get_opcode_str(int inst, int valid_inst);
void parse_register(char* readbuf, int reg_num, char*** contents, char** reg_names);
int get_time();


// Helper function for ncurses gui setup
WINDOW *create_newwin(int height, int width, int starty, int startx, int color){
  WINDOW *local_win;
  local_win = newwin(height, width, starty, startx);
  wbkgd(local_win,COLOR_PAIR(color));
  wattron(local_win,COLOR_PAIR(color));
  box(local_win,0,0);
  wrefresh(local_win);
  return local_win;
}

// Function to draw positive edge or negative edge in clock window
void update_clock(char clock_val){
  static char cur_clock_val = 0;
  // Adding extra check on cycles because:
  //  - if the user, right at the beginning of the simulation, jumps to a new
  //    time right after a negative clock edge, the clock won't be drawn
  if((clock_val != cur_clock_val) || strncmp(cycles[history_num],"      0",7) == 1){
    mvwaddch(clock_win,3,7,ACS_VLINE | A_BOLD);
    if(clock_val == 1){

      //we have a posedge
      mvwaddch(clock_win,2,1,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,ACS_ULCORNER | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      mvwaddch(clock_win,4,1,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_LRCORNER | A_BOLD);
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
    } else {

      //we have a negedge
      mvwaddch(clock_win,4,1,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,ACS_LLCORNER | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      mvwaddch(clock_win,2,1,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_HLINE | A_BOLD);
      waddch(clock_win,ACS_URCORNER | A_BOLD);
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
      waddch(clock_win,' ');
    }
  }
  cur_clock_val = clock_val;
  wrefresh(clock_win);
}

// Function to create and initialize the gui
// Color pairs are (foreground color, background color)
// If you don't like the dark backgrounds, a safe bet is to have
//   COLOR_BLUE/BLACK foreground and COLOR_WHITE background
void setup_gui(FILE *fp){
  initscr();
  if(has_colors()){
    start_color();
    init_pair(1,COLOR_CYAN,COLOR_BLACK);    // shell background
    init_pair(2,COLOR_YELLOW,COLOR_RED);
    init_pair(3,COLOR_RED,COLOR_BLACK);
    init_pair(4,COLOR_YELLOW,COLOR_BLUE);   // title window
    init_pair(5,COLOR_YELLOW,COLOR_BLACK);  // register/signal windows
    init_pair(6,COLOR_RED,COLOR_BLACK);
    init_pair(7,COLOR_MAGENTA,COLOR_BLACK); // pipeline window
  }
  curs_set(0);
  noecho();
  cbreak();
  keypad(stdscr,TRUE);
  wbkgd(stdscr,COLOR_PAIR(1));
  wrefresh(stdscr);
  int pipe_width=0;

  //instantiate the title window at top of screen
  title_win = create_newwin(TITLE_WIN_HIGHT,COLS,0,0,4);
  mvwprintw(title_win,1,1,"SIMULATION INTERFACE V2");
  mvwprintw(title_win,1,COLS-22,"RUI HAN/CHENGHSIUNG CHEN");
  wrefresh(title_win);

  //instantiate time window at right hand side of screen
  time_win = create_newwin(TIME_WIN_HIGHT,TIME_WIN_WIDTH,TITLE_WIN_HIGHT,COLS-TIME_WIN_WIDTH,5);
  mvwprintw(time_win,0,3,"TIME");
  wrefresh(time_win);

  //instantiate a sim time window which states the actual simlator time
  sim_time_win = create_newwin(SIM_TIME_WIN_HIGHT,SIM_TIME_WIN_WIDTH,TITLE_WIN_HIGHT+TIME_WIN_HIGHT,COLS-SIM_TIME_WIN_WIDTH,5);
  mvwprintw(sim_time_win,0,1,"SIM TIME");
  wrefresh(sim_time_win);

  //instantiate a window to show which clock edge this is
  clock_win = create_newwin(CLOCK_WIN_HIGHT,CLOCK_WIN_WIDTH,TITLE_WIN_HIGHT,COLS-ARF_WIDTH,5);
  mvwprintw(clock_win,0,5,"CLOCK");
  mvwprintw(clock_win,1,1,"cycle:");
  update_clock(0);
  wrefresh(clock_win);

  // instantiate a window for the ARF on the right side
  arf_win = create_newwin(ARF_HIGHT,ARF_WIDTH,TITLE_WIN_HIGHT+CLOCK_WIN_HIGHT,COLS-ARF_WIDTH,5);
  mvwprintw(arf_win,0,13,"ARF");
  int i=0;
  char tmp_buf[32];
  for (; i < NUM_ARF; i++) {
    sprintf(tmp_buf, "PR%02d: ", i);
    mvwprintw(arf_win,i+1,1,tmp_buf);
  }
  wrefresh(arf_win);

  //instantiate window to visualize instructions in pipeline below title
  pipe_win = create_newwin(PIPE_WIN_HIGHT,COLS-ARF_WIDTH,TITLE_WIN_HIGHT,0,7);
  pipe_width = (COLS-ARF_WIDTH)/6;
  mvwprintw(pipe_win,0,(COLS-8)/2,"PIPELINE");
  wattron(pipe_win,A_UNDERLINE);
  mvwprintw(pipe_win,1,pipe_width-2,"IF");
  mvwprintw(pipe_win,1,2*pipe_width-2,"ID");
  mvwprintw(pipe_win,1,3*pipe_width-2,"EX");
  mvwprintw(pipe_win,1,4*pipe_width-3,"CPLT");
  mvwprintw(pipe_win,1,5*pipe_width-2,"RT");
  mvwprintw(pipe_win,2,pipe_width/2-2,"n0");
  mvwprintw(pipe_win,4,pipe_width/2-2,"n1");
  wattroff(pipe_win,A_UNDERLINE);
  wrefresh(pipe_win);

  //instantiate window to visualize IF stage (including IF/ID)
  if_win = create_newwin(IF_WIN_HIGHT,IF_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,0,5);
  mvwprintw(if_win,0,10,"IF STAGE");
  wrefresh(if_win);

  //instantiate window to visualize IF/ID signals
  if_id_win = create_newwin(IF_ID_WIN_HIGHT,IF_ID_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+IF_WIN_HIGHT,0,5);
  mvwprintw(if_id_win,0,12,"IF/ID");
  wrefresh(if_id_win);

  //instantiate a window to visualize ID stage
  id_win = create_newwin(ID_WIN_HIGHT,ID_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+IF_WIN_HIGHT+IF_ID_WIN_HIGHT,0,5);
  mvwprintw(id_win,0,10,"ID STAGE");
  wrefresh(id_win);

  rs_win = create_newwin(RS_WIN_HIGHT,RS_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+ID_EX_WIN_HIGHT+EX_WIN_HIGHT,IF_WIN_WIDTH,5);
  mvwprintw(rs_win,0,3,"RS_T");
  wrefresh(rs_win);

  rs_t1_win = create_newwin(RS_T1_WIN_HIGHT,RS_T1_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+ID_EX_WIN_HIGHT+EX_WIN_HIGHT,RS_WIN_WIDTH+IF_WIN_WIDTH,5);
  mvwprintw(rs_t1_win,0,2,"RS_T1");
  wrefresh(rs_t1_win);

  rs_tr1_win = create_newwin(RS_TR1_WIN_HIGHT,RS_TR1_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+ID_EX_WIN_HIGHT+EX_WIN_HIGHT,RS_WIN_WIDTH+RS_T1_WIN_WIDTH+IF_WIN_WIDTH, 5);
  mvwprintw(rs_tr1_win,0,1,"RS_Rdy1");
  wrefresh(rs_tr1_win);

  rs_t2_win = create_newwin(RS_T2_WIN_HIGHT,RS_T2_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+ID_EX_WIN_HIGHT+EX_WIN_HIGHT,RS_WIN_WIDTH+RS_T1_WIN_WIDTH+RS_TR1_WIN_WIDTH+IF_WIN_WIDTH,5);
  mvwprintw(rs_t2_win,0,2,"RS_T2");
  wrefresh(rs_t2_win);

  rs_tr2_win = create_newwin(RS_TR2_WIN_HIGHT,RS_TR2_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+ID_EX_WIN_HIGHT+EX_WIN_HIGHT,RS_WIN_WIDTH+RS_T1_WIN_WIDTH+RS_TR1_WIN_WIDTH+RS_T2_WIN_WIDTH+IF_WIN_WIDTH,5);
  mvwprintw(rs_tr2_win,0,1,"RS_Rdy2");
  wrefresh(rs_tr2_win);

  rs_bz_win = create_newwin(RS_BZ_WIN_HIGHT,RS_BZ_WIN_WIDTH,TITLE_WIN_HIGHT+PIPE_WIN_HIGHT+ID_EX_WIN_HIGHT+EX_WIN_HIGHT,RS_WIN_WIDTH+RS_T1_WIN_WIDTH+RS_TR1_WIN_WIDTH+RS_T2_WIN_WIDTH+RS_TR2_WIN_WIDTH+IF_WIN_WIDTH,5);
  mvwprintw(rs_bz_win,0,1,"RS_busy");
  wrefresh(rs_bz_win);

  //instantiate a window to visualize ID/EX signals
  id_ex_win = create_newwin(ID_EX_WIN_HIGHT,ID_EX_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH,5);
  mvwprintw(id_ex_win,0,12,"ID/EX");
  wrefresh(id_ex_win);

  //instantiate a window to visualize EX stage
  ex_win = create_newwin(EX_WIN_HIGHT,EX_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+ID_EX_WIN_HIGHT,IF_WIN_WIDTH,5);
  mvwprintw(ex_win,0,10,"EX STAGE");
  wrefresh(ex_win);

  //instantiate a window to visualize EX/MEM
  ex_mem_win = create_newwin(EX_MEM_WIN_HIGHT,EX_MEM_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH,5);
  mvwprintw(ex_mem_win,0,12,"EX/MEM");
  wrefresh(ex_mem_win);

  //instantiate a window to visualize MEM stage
  mem_win = create_newwin(MEM_WIN_HIGHT,MEM_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+EX_MEM_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH,5);
  mvwprintw(mem_win,0,10,"MEM STAGE");
  wrefresh(mem_win);

  //instantiate a window to visualize MEM/WB
  mem_wb_win = create_newwin(MEM_WB_WIN_HIGHT,MEM_WB_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+EX_MEM_WIN_HIGHT+MEM_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH,5);
  mvwprintw(mem_wb_win,0,12,"MEM/WB");
  wrefresh(mem_wb_win);

  rob_rd_win = create_newwin(ROB_RD_WIN_HIGHT,ROB_RD_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH,5);
  mvwprintw(rob_rd_win,0,1,"ROB_Rdy");
  wrefresh(rob_rd_win);

  rob_tn_win = create_newwin(ROB_TN_WIN_HIGHT,ROB_TN_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH,5);
  mvwprintw(rob_tn_win,0,2,"ROB_Tnew");
  wrefresh(rob_tn_win);

  rob_to_win = create_newwin(ROB_TO_WIN_HIGHT,ROB_TO_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH,5);
  mvwprintw(rob_to_win,0,2,"ROB_Told");
  wrefresh(rob_to_win);

  rob_st_win = create_newwin(ROB_ST_WIN_HIGHT,ROB_ST_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH+ROB_TO_WIN_WIDTH,5);
  mvwprintw(rob_st_win,0,2,"ROB_ST");
  wrefresh(rob_st_win);

  fr_win = create_newwin(FR_WIN_HIGHT,FR_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH+ROB_TO_WIN_WIDTH+ROB_ST_WIN_WIDTH,5);
  mvwprintw(fr_win,0,2,"Freelist");
  wrefresh(fr_win);

  map_win = create_newwin(MAP_WIN_HIGHT,MAP_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH+ROB_TO_WIN_WIDTH+ROB_ST_WIN_WIDTH+FR_WIN_WIDTH,5);
  mvwprintw(map_win,0,2,"MapTag");
  wrefresh(map_win);

  map_rd_win = create_newwin(MAP_RD_WIN_HIGHT,MAP_RD_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH+ROB_TO_WIN_WIDTH+ROB_ST_WIN_WIDTH+FR_WIN_WIDTH+MAP_WIN_WIDTH,5);
  mvwprintw(map_rd_win,0,2,"MapRdy");
  wrefresh(map_rd_win);

  sq_win = create_newwin(SQ_WIN_HIGHT,SQ_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+MAP_RD_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH,5);
  mvwprintw(sq_win,0,4,"SQ_data and SQ_addr");
  wrefresh(sq_win);

  sq_rd_win = create_newwin(SQ_RD_WIN_HIGHT,SQ_RD_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+MAP_RD_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+SQ_WIN_WIDTH,5);
  mvwprintw(sq_rd_win,0,4,"SQ_ready and others");
  wrefresh(sq_rd_win);

  lq_win = create_newwin(LQ_WIN_HIGHT,LQ_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+MAP_RD_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+SQ_WIN_WIDTH+SQ_RD_WIN_WIDTH,5);
  mvwprintw(lq_win,0,0,"LQ_data from Dcahce/Forward");
  wrefresh(lq_win);

  lq_addr_win = create_newwin(LQ_ADDR_WIN_HIGHT,LQ_ADDR_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+MAP_RD_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+SQ_WIN_WIDTH+SQ_RD_WIN_WIDTH+LQ_WIN_WIDTH,5);
  mvwprintw(lq_addr_win,0,0,"LQ_address/dest_reg");
  wrefresh(lq_addr_win);

  lq_busy_win = create_newwin(LQ_BUSY_WIN_HIGHT,LQ_BUSY_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+MAP_RD_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+SQ_WIN_WIDTH+SQ_RD_WIN_WIDTH+LQ_WIN_WIDTH+LQ_ADDR_WIN_WIDTH,5);
  mvwprintw(lq_busy_win,0,0,"LQ_store_pos/busy");
  wrefresh(lq_busy_win);

  lq_dcache_win = create_newwin(LQ_D_WIN_HIGHT,LQ_D_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+MAP_RD_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+SQ_WIN_WIDTH+SQ_RD_WIN_WIDTH+LQ_WIN_WIDTH+LQ_ADDR_WIN_WIDTH+LQ_BUSY_WIN_WIDTH,5);
  mvwprintw(lq_dcache_win,0,0,"LQ_dcache address/index");
  wrefresh(lq_dcache_win);

  dcache_win = create_newwin(DCACHE_WIN_HIGHT,DCACHE_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH+ROB_TO_WIN_WIDTH+ROB_ST_WIN_WIDTH+FR_WIN_WIDTH+MAP_WIN_WIDTH+MAP_RD_WIN_WIDTH,5);
  mvwprintw(dcache_win,0,10,"dcache");
  wrefresh(dcache_win);

  dcache_con_win = create_newwin(DCACHE_CON_WIN_HIGHT,DCACHE_CON_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+DCACHE_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH+ROB_TO_WIN_WIDTH+ROB_ST_WIN_WIDTH+FR_WIN_WIDTH+MAP_WIN_WIDTH+MAP_RD_WIN_WIDTH,5);
  mvwprintw(dcache_con_win,0,5,"dcache_controller");
  wrefresh(dcache_con_win);

  icache_win =
create_newwin(ICACHE_WIN_HIGHT,ICACHE_WIN_WIDTH,PIPE_WIN_HIGHT+TITLE_WIN_HIGHT+DCACHE_WIN_HIGHT+DCACHE_CON_WIN_HIGHT,IF_WIN_WIDTH+ID_EX_WIN_WIDTH+EX_MEM_WIN_WIDTH+ROB_RD_WIN_WIDTH+ROB_TN_WIN_WIDTH+ROB_TO_WIN_WIDTH+ROB_ST_WIN_WIDTH+FR_WIN_WIDTH+MAP_WIN_WIDTH+MAP_RD_WIN_WIDTH,5);
  mvwprintw(icache_win,0,10,"icache");
  wrefresh(icache_win);


  //instantiate a window to visualize WB stage
  wb_win = create_newwin((num_wb_regs+2),30,LINES-(num_wb_regs+2),0,5);
  mvwprintw(wb_win,0,10,"WB_STAGE");
  wrefresh(wb_win);

  //instantiate an instructional window to help out the user some
  instr_win = create_newwin(7,30,LINES-7,COLS-55,5);
  mvwprintw(instr_win,0,9,"INSTRUCTIONS");
  wattron(instr_win,COLOR_PAIR(5));
  mvwaddstr(instr_win,1,1,"'n'   -> Next clock edge");
  mvwaddstr(instr_win,2,1,"'b'   -> Previous clock edge");
  mvwaddstr(instr_win,3,1,"'c/g' -> Goto specified time");
  mvwaddstr(instr_win,4,1,"'r'   -> Run to end of sim");
  mvwaddstr(instr_win,5,1,"'q'   -> Quit Simulator");
  wrefresh(instr_win);
  
  // instantiate window to visualize misc regs/wires
  misc_win = create_newwin(5,COLS-25-60,LINES-5,30,5);
  mvwprintw(misc_win,0,(COLS-30-30)/2-6,"MISC SIGNALS");
  wrefresh(misc_win);

  refresh();
}

// This function updates all of the signals being displayed with the values
// from time history_num_in (this is the index into all of the data arrays).
// If the value changed from what was previously display, the signal has its
// display color inverted to make it pop out.
void parsedata(int history_num_in){
  static int old_history_num_in=0;
  static int old_head_position=0;
  static int old_tail_position=0;
  int i=0;
  int data_counter=0;
  char *opcode_0;
  char *opcode_1;
  int tmp_0=0;
  int tmp_1=0;
  int tmp_val_0=0;
  int tmp_val_1=0;
  char tmp_buf_0[32];
  char tmp_buf_1[32];
  int pipe_width = (COLS-ARF_WIDTH)/6;

  // Handle updating resets
  if (resets[history_num_in]) {
    wattron(title_win,A_REVERSE);
    mvwprintw(title_win,1,(COLS/2)-3,"RESET");
    wattroff(title_win,A_REVERSE);
  }
  else if (done_time != 0 && (history_num_in == done_time)) {
    wattron(title_win,A_REVERSE);
    mvwprintw(title_win,1,(COLS/2)-3,"DONE ");
    wattroff(title_win,A_REVERSE);
  }
  else
    mvwprintw(title_win,1,(COLS/2)-3,"     ");
  wrefresh(title_win);

  // Handle updating the pipeline window
  for(i=0; i < NUM_STAGES; i++) {
    strncpy(tmp_buf_0,inst_contents[history_num_in]+i*9,8);
    strncpy(tmp_buf_1,inst_contents[history_num_in]+(i+NUM_STAGES)*9,8);
    tmp_buf_0[9] = '\0';
    tmp_buf_1[9] = '\0';
    sscanf(tmp_buf_0,"%8x", &tmp_val_0);
    sscanf(tmp_buf_1,"%8x", &tmp_val_1);
    tmp_0 = (int)inst_contents[history_num_in][8+(i*9)] - (int)'0';
    tmp_1 = (int)inst_contents[history_num_in][8+((i+NUM_STAGES)*9)] - (int)'0';
    opcode_0 = get_opcode_str(tmp_val_0, tmp_0);
    opcode_1 = get_opcode_str(tmp_val_1, tmp_1);

    // clear string and overwrite
    mvwprintw(pipe_win,2,pipe_width*(i+1)-2-5,"          ");
    if (strncmp(tmp_buf_0,"xxxxxxxx",8) == 0)
      mvwaddnstr(pipe_win,2,pipe_width*(i+1)-2-4,tmp_buf_0,8);
    else
      mvwaddstr(pipe_win,2,pipe_width*(i+1)-2-(strlen(opcode_0)/2),opcode_0);
    mvwprintw(pipe_win,4,pipe_width*(i+1)-2-5,"          ");
    if (strncmp(tmp_buf_1,"xxxxxxxx",8) == 0)
      mvwaddnstr(pipe_win,4,pipe_width*(i+1)-2-4,tmp_buf_1,8);
    else
      mvwaddstr(pipe_win,4,pipe_width*(i+1)-2-(strlen(opcode_1)/2),opcode_1);

    if (tmp_0==0 || tmp_0==((int)'x'-(int)'0'))
      mvwprintw(pipe_win,3,pipe_width*(i+1)-2,"I");
    else
      mvwprintw(pipe_win,3,pipe_width*(i+1)-2,"V");
    if (tmp_1==0 || tmp_1==((int)'x'-(int)'0'))
      mvwprintw(pipe_win,5,pipe_width*(i+1)-2,"I");
    else
      mvwprintw(pipe_win,5,pipe_width*(i+1)-2,"V");
  }
  wrefresh(pipe_win);
  // Handle updating the ARF window
  for (i=0; i < NUM_ARF; i++) {
    if (strncmp(arf_contents[history_num_in]+i*16,
                arf_contents[old_history_num_in]+i*16,16))
      wattron(arf_win, A_REVERSE);
    else
      wattroff(arf_win, A_REVERSE);
    mvwaddnstr(arf_win,i+1,6,arf_contents[history_num_in]+i*16,16);
  }
  wrefresh(arf_win);

  // Handle updating the IF window
  for(i=0;i<num_if_regs;i++){
    if (strcmp(if_contents[history_num_in][i],
                if_contents[old_history_num_in][i]))
      wattron(if_win, A_REVERSE);
    else
      wattroff(if_win, A_REVERSE);
    mvwaddstr(if_win,i+1,strlen(if_reg_names[i])+3,if_contents[history_num_in][i]);
  }
  wrefresh(if_win);

  // Handle updating the IF/ID window
  for(i=0;i<num_if_id_regs;i++){
    if (strcmp(if_id_contents[history_num_in][i],
                if_id_contents[old_history_num_in][i]))
      wattron(if_id_win, A_REVERSE);
    else
      wattroff(if_id_win, A_REVERSE);
    mvwaddstr(if_id_win,i+1,strlen(if_id_reg_names[i])+3,if_id_contents[history_num_in][i]);
  }
  wrefresh(if_id_win);

  // Handle updating the ID window
  for(i=0;i<num_id_regs;i++){
    if (strcmp(id_contents[history_num_in][i],
                id_contents[old_history_num_in][i]))
      wattron(id_win, A_REVERSE);
    else
      wattroff(id_win, A_REVERSE);
    mvwaddstr(id_win,i+1,strlen(id_reg_names[i])+3,id_contents[history_num_in][i]);
  }
  wrefresh(id_win);

  // Handle updating the ID/EX window
  for(i=0;i<num_id_ex_regs;i++){
    if (strcmp(id_ex_contents[history_num_in][i],
                id_ex_contents[old_history_num_in][i]))
      wattron(id_ex_win, A_REVERSE);
    else
      wattroff(id_ex_win, A_REVERSE);
    mvwaddstr(id_ex_win,i+1,strlen(id_ex_reg_names[i])+3,id_ex_contents[history_num_in][i]);
  }
  wrefresh(id_ex_win);

  // Handle updating the EX window
  for(i=0;i<num_ex_regs;i++){
    if (strcmp(ex_contents[history_num_in][i],
                ex_contents[old_history_num_in][i]))
      wattron(ex_win, A_REVERSE);
    else
      wattroff(ex_win, A_REVERSE);
    mvwaddstr(ex_win,i+1,strlen(ex_reg_names[i])+3,ex_contents[history_num_in][i]);
  }
  wrefresh(ex_win);

  // Handle updating the EX/MEM window
  for(i=0;i<num_ex_mem_regs;i++){
    if (strcmp(ex_mem_contents[history_num_in][i],
                ex_mem_contents[old_history_num_in][i]))
      wattron(ex_mem_win, A_REVERSE);
    else
      wattroff(ex_mem_win, A_REVERSE);
    mvwaddstr(ex_mem_win,i+1,strlen(ex_mem_reg_names[i])+3,ex_mem_contents[history_num_in][i]);
  }
  wrefresh(ex_mem_win);

  // Handle updating the MEM window
  for(i=0;i<num_mem_regs;i++){
    if (strcmp(mem_contents[history_num_in][i],
                mem_contents[old_history_num_in][i]))
      wattron(mem_win, A_REVERSE);
    else
      wattroff(mem_win, A_REVERSE);
    mvwaddstr(mem_win,i+1,strlen(mem_reg_names[i])+3,mem_contents[history_num_in][i]);
  }
  wrefresh(mem_win);

  // Handle updating the MEM/WB window
  for(i=0;i<num_mem_wb_regs;i++){
    if (strcmp(mem_wb_contents[history_num_in][i],
                mem_wb_contents[old_history_num_in][i]))
      wattron(mem_wb_win, A_REVERSE);
    else
      wattroff(mem_wb_win, A_REVERSE);
    mvwaddstr(mem_wb_win,i+1,strlen(mem_wb_reg_names[i])+3,mem_wb_contents[history_num_in][i]);
  }
  wrefresh(mem_wb_win);

  // Handle updating the WB window
  for(i=0;i<num_wb_regs;i++){
    if (strcmp(wb_contents[history_num_in][i],
                wb_contents[old_history_num_in][i]))
      wattron(wb_win, A_REVERSE);
    else
      wattroff(wb_win, A_REVERSE);
    mvwaddstr(wb_win,i+1,strlen(wb_reg_names[i])+3,wb_contents[history_num_in][i]);
  }
  wrefresh(wb_win);

  // Handle updating the RS window
  for(i=0;i<num_rs_regs;i++){
    if (strcmp(rs_contents[history_num_in][i],
                rs_contents[old_history_num_in][i]))
      wattron(rs_win, A_REVERSE);
    else
      wattroff(rs_win, A_REVERSE);
	int t_num = (int)strtol(rs_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(rs_win,i+1,strlen(rs_reg_names[i])+3,t_str);
  }
  wrefresh(rs_win);

  for(i=0;i<num_rs_t1_regs;i++){
    if (strcmp(rs_t1_contents[history_num_in][i],
                rs_t1_contents[old_history_num_in][i]))
      wattron(rs_t1_win, A_REVERSE);
    else
      wattroff(rs_t1_win, A_REVERSE);
	int t_num = (int)strtol(rs_t1_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(rs_t1_win,i+1,strlen(rs_t1_reg_names[i])+3,t_str);
  }
  wrefresh(rs_t1_win);

  for(i=0;i<num_rs_tr1_regs;i++){
    if (strcmp(rs_tr1_contents[history_num_in][i],
                rs_tr1_contents[old_history_num_in][i]))
      wattron(rs_tr1_win, A_REVERSE);
    else
      wattroff(rs_tr1_win, A_REVERSE);
	mvwaddstr(rs_tr1_win,i+1,strlen(rs_tr1_reg_names[i])+3,rs_tr1_contents[history_num_in][i]);
  }
  wrefresh(rs_tr1_win);

  for(i=0;i<num_rs_t2_regs;i++){
    if (strcmp(rs_t2_contents[history_num_in][i],
                rs_t2_contents[old_history_num_in][i]))
      wattron(rs_t2_win, A_REVERSE);
    else
      wattroff(rs_t2_win, A_REVERSE);
	int t_num = (int)strtol(rs_t2_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(rs_t2_win,i+1,strlen(rs_t2_reg_names[i])+3,t_str);
  }
  wrefresh(rs_t2_win);

  for(i=0;i<num_rs_tr2_regs;i++){
    if (strcmp(rs_tr2_contents[history_num_in][i],
                rs_tr2_contents[old_history_num_in][i]))
      wattron(rs_tr2_win, A_REVERSE);
    else
      wattroff(rs_tr2_win, A_REVERSE);
	mvwaddstr(rs_tr2_win,i+1,strlen(rs_tr2_reg_names[i])+3,rs_tr2_contents[history_num_in][i]);
  }
  wrefresh(rs_tr2_win);

  for(i=0;i<num_rs_bz_regs;i++){
    if (strcmp(rs_bz_contents[history_num_in][i],
                rs_bz_contents[old_history_num_in][i]))
      wattron(rs_bz_win, A_REVERSE);
    else
      wattroff(rs_bz_win, A_REVERSE);
	mvwaddstr(rs_bz_win,i+1,strlen(rs_bz_reg_names[i])+3,rs_bz_contents[history_num_in][i]);
  }
  wrefresh(rs_bz_win);

  for(i=0;i<num_rob_rd_regs;i++){
    if (strcmp(rob_rd_contents[history_num_in][i],
                rob_rd_contents[old_history_num_in][i]))
      wattron(rob_rd_win, A_REVERSE);
    else
      wattroff(rob_rd_win, A_REVERSE);
	mvwaddstr(rob_rd_win,i+1,strlen(rob_rd_reg_names[i])+3,rob_rd_contents[history_num_in][i]);
  }
  wrefresh(rob_rd_win);

  for(i=0;i<num_rob_st_regs;i++){
    if (strcmp(rob_st_contents[history_num_in][i],
                rob_st_contents[old_history_num_in][i]))
      wattron(rob_st_win, A_REVERSE);
    else
      wattroff(rob_st_win, A_REVERSE);
    //int t_num = (int)strtol(rob_st_contents[history_num_in][i], NULL, 16);
	//char t_str[3];
	//sprintf(t_str, "%d", t_num);
	mvwaddstr(rob_st_win,i+1,strlen(rob_st_reg_names[i])+3,rob_st_contents[history_num_in][i]);
  }
  wrefresh(rob_st_win);

  for(i=0;i<num_rob_tn_regs;i++){
    if (strcmp(rob_tn_contents[history_num_in][i],
                rob_tn_contents[old_history_num_in][i]))
      wattron(rob_tn_win, A_REVERSE);
    else
      wattroff(rob_tn_win, A_REVERSE);
	int t_num = (int)strtol(rob_tn_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(rob_tn_win,i+1,strlen(rob_tn_reg_names[i])+3,t_str);
  }
  wrefresh(rob_tn_win);

  for(i=0;i<num_rob_to_regs;i++){
    if (strcmp(rob_to_contents[history_num_in][i],
                rob_to_contents[old_history_num_in][i]))
      wattron(rob_to_win, A_REVERSE);
    else
      wattroff(rob_to_win, A_REVERSE);
	int t_num = (int)strtol(rob_to_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(rob_to_win,i+1,strlen(rob_to_reg_names[i])+3,t_str);
  }
  wrefresh(rob_to_win);

  for(i=0;i<num_fr_regs;i++){
    if (strcmp(fr_contents[history_num_in][i],
                fr_contents[old_history_num_in][i]))
      wattron(fr_win, A_REVERSE);
    else
      wattroff(fr_win, A_REVERSE);
	int t_num = (int)strtol(fr_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(fr_win,i+1,strlen(fr_reg_names[i])+3,t_str);
  }
  wrefresh(fr_win);

  for(i=0;i<num_map_regs;i++){
    if (strcmp(map_contents[history_num_in][i],
                map_contents[old_history_num_in][i]))
      wattron(map_win, A_REVERSE);
    else
      wattroff(map_win, A_REVERSE);
	int t_num = (int)strtol(map_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(map_win,i+1,strlen(map_reg_names[i])+3,t_str);
  }
  wrefresh(map_win);

  for(i=0;i<num_map_rd_regs;i++){
    if (strcmp(map_rd_contents[history_num_in][i],
                map_rd_contents[old_history_num_in][i]))
      wattron(map_rd_win, A_REVERSE);
    else
      wattroff(map_rd_win, A_REVERSE);
	int t_num = (int)strtol(map_rd_contents[history_num_in][i], NULL, 16);
	char t_str[3];
	if (t_num == 31) {
		t_str[0] = 45;
		t_str[1] = 45;
		t_str[2] = '\0';
	} else {
		sprintf(t_str, "%2d", t_num);
	}
    mvwaddstr(map_rd_win,i+1,strlen(map_rd_reg_names[i])+3,t_str);
  }
  wrefresh(map_rd_win);

  for(i=0;i<num_sq_regs;i++){
    if (strcmp(sq_contents[history_num_in][i],
                sq_contents[old_history_num_in][i]))
      wattron(sq_win, A_REVERSE);
    else
      wattroff(sq_win, A_REVERSE);
    mvwaddstr(sq_win,i+1,strlen(sq_reg_names[i])+3,sq_contents[history_num_in][i]);
  }
  wrefresh(sq_win);

  for(i=0;i<num_sq_rd_regs;i++){
    if (strcmp(sq_rd_contents[history_num_in][i],
                sq_rd_contents[old_history_num_in][i]))
      wattron(sq_rd_win, A_REVERSE);
    else
      wattroff(sq_rd_win, A_REVERSE);
    mvwaddstr(sq_rd_win,i+1,strlen(sq_rd_reg_names[i])+3,sq_rd_contents[history_num_in][i]);
  }
  wrefresh(sq_rd_win);

  for(i=0;i<num_lq_regs;i++){
    if (strcmp(lq_contents[history_num_in][i],
                lq_contents[old_history_num_in][i]))
      wattron(lq_win, A_REVERSE);
    else
      wattroff(lq_win, A_REVERSE);
    mvwaddstr(lq_win,i+1,strlen(lq_reg_names[i])+3,lq_contents[history_num_in][i]);
  }
  wrefresh(lq_win);

  for(i=0;i<num_lq_addr_regs;i++){
    if (strcmp(lq_addr_contents[history_num_in][i],
                lq_addr_contents[old_history_num_in][i]))
      wattron(lq_addr_win, A_REVERSE);
    else
      wattroff(lq_addr_win, A_REVERSE);
    mvwaddstr(lq_addr_win,i+1,strlen(lq_addr_reg_names[i])+3,lq_addr_contents[history_num_in][i]);
  }
  wrefresh(lq_addr_win);

  for(i=0;i<num_lq_busy_regs;i++){
    if (strcmp(lq_busy_contents[history_num_in][i],
                lq_busy_contents[old_history_num_in][i]))
      wattron(lq_busy_win, A_REVERSE);
    else
      wattroff(lq_busy_win, A_REVERSE);
    mvwaddstr(lq_busy_win,i+1,strlen(lq_busy_reg_names[i])+3,lq_busy_contents[history_num_in][i]);
  }
  wrefresh(lq_busy_win);

  for(i=0;i<num_lq_dcache_regs;i++){
    if (strcmp(lq_dcache_contents[history_num_in][i],
                lq_dcache_contents[old_history_num_in][i]))
      wattron(lq_dcache_win, A_REVERSE);
    else
      wattroff(lq_dcache_win, A_REVERSE);
    mvwaddstr(lq_dcache_win,i+1,strlen(lq_dcache_reg_names[i])+3,lq_dcache_contents[history_num_in][i]);
  }
  wrefresh(lq_dcache_win);

  for(i=0;i<num_dcache_regs;i++){
    if (strcmp(dcache_contents[history_num_in][i],
                dcache_contents[old_history_num_in][i]))
      wattron(dcache_win, A_REVERSE);
    else
      wattroff(dcache_win, A_REVERSE);
    mvwaddstr(dcache_win,i+1,strlen(dcache_reg_names[i])+3,dcache_contents[history_num_in][i]);
  }
  wrefresh(dcache_win);

  for(i=0;i<num_dcache_con_regs;i++){
    if (strcmp(dcache_con_contents[history_num_in][i],
                dcache_con_contents[old_history_num_in][i]))
      wattron(dcache_con_win, A_REVERSE);
    else
      wattroff(dcache_con_win, A_REVERSE);
    mvwaddstr(dcache_con_win,i+1,strlen(dcache_con_reg_names[i])+3,dcache_con_contents[history_num_in][i]);
  }
  wrefresh(dcache_con_win);

  for(i=0;i<num_icache_regs;i++){
    if (strcmp(icache_contents[history_num_in][i],
                icache_contents[old_history_num_in][i]))
      wattron(icache_win, A_REVERSE);
    else
      wattroff(icache_win, A_REVERSE);
    mvwaddstr(icache_win,i+1,strlen(icache_reg_names[i])+3,icache_contents[history_num_in][i]);
  }
  wrefresh(icache_win);

  // Handle updating the misc. window
  int row=1,col=1;
  for (i=0;i<num_misc_regs;i++){
    if (strcmp(misc_contents[history_num_in][i],
                misc_contents[old_history_num_in][i]))
      wattron(misc_win, A_REVERSE);
    else
      wattroff(misc_win, A_REVERSE);
    

    mvwaddstr(misc_win,(i%5)+1,((i/5)*30)+strlen(misc_reg_names[i])+3,misc_contents[history_num_in][i]);
    if ((++row)>6) {
      row=1;
      col+=30;
    }
  }
  wrefresh(misc_win);
  //update the time window
  mvwaddstr(time_win,1,1,timebuffer[history_num_in]);
  wrefresh(time_win);

  //update to the correct clock edge for this history
  mvwaddstr(clock_win,1,7,cycles[history_num_in]);
  update_clock(clocks[history_num_in]);

  //save the old history index to check for changes later
  old_history_num_in = history_num_in;
}

// Parse a line of data output from the testbench
int processinput(){
  static int byte_num = 0;
  static int if_reg_num = 0;
  static int if_id_reg_num = 0;
  static int id_reg_num = 0;
  static int id_ex_reg_num = 0;
  static int ex_reg_num = 0;
  static int ex_mem_reg_num = 0;
  static int mem_reg_num = 0;
  static int mem_wb_reg_num = 0;
  static int wb_reg_num = 0;
  static int rs_reg_num = 0;
  static int rs_tr1_reg_num = 0;
  static int rs_t1_reg_num = 0;
  static int rs_tr2_reg_num = 0;
  static int rs_t2_reg_num = 0;
  static int rs_bz_reg_num = 0;

  static int rob_rd_reg_num = 0;
  static int rob_tn_reg_num = 0;
  static int rob_to_reg_num = 0;
  static int rob_st_reg_num = 0;

  static int fr_reg_num = 0;
  static int map_reg_num = 0;
  static int map_rd_reg_num = 0;
  static int sq_reg_num = 0;
  static int sq_rd_reg_num = 0;
  static int lq_reg_num = 0;
  static int lq_addr_reg_num = 0;
  static int lq_busy_reg_num = 0;
  static int lq_dcache_reg_num = 0;
  static int dcache_reg_num = 0;
  static int dcache_con_reg_num = 0;
  static int icache_reg_num = 0;
  static int misc_reg_num = 0;
  int tmp_len;
  char name_buf[32];
  char val_buf[32];

  //get rid of newline character
  readbuffer[strlen(readbuffer)-1] = 0;

  if(strncmp(readbuffer,"t",1) == 0){

    //We are getting the timestamp
    strcpy(timebuffer[history_num],readbuffer+1);
  }else if(strncmp(readbuffer,"c",1) == 0){

    //We have a clock edge/cycle count signal
    if(strncmp(readbuffer+1,"0",1) == 0)
      clocks[history_num] = 0;
    else
      clocks[history_num] = 1;

    // grab clock count (for some reason, first clock count sent is
    // too many digits, so check for this)
    strncpy(cycles[history_num],readbuffer+2,7);
    if (strncmp(cycles[history_num],"       ",7) == 0)
      cycles[history_num][6] = '0';
    
  }else if(strncmp(readbuffer,"z",1) == 0){
    
    // we have a reset signal
    if(strncmp(readbuffer+1,"0",1) == 0)
      resets[history_num] = 0;
    else
      resets[history_num] = 1;

  }else if(strncmp(readbuffer,"a",1) == 0){
    // We are getting ARF registers
    strcpy(arf_contents[history_num], readbuffer+1);

  }else if(strncmp(readbuffer,"p",1) == 0){
    // We are getting information about which instructions are in each stage
    strcpy(inst_contents[history_num], readbuffer+1);

  }else if(strncmp(readbuffer,"-",1) == 0){
    // We are getting information about which instructions are in each stage
    strcpy(inst_contents[history_num]+9*NUM_STAGES, readbuffer+1);

  }else if(strncmp(readbuffer,"f",1) == 0){
    // We are getting an IF register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, if_reg_num, if_contents, if_reg_names);
      mvwaddstr(if_win,if_reg_num+1,1,if_reg_names[if_reg_num]);
      waddstr(if_win, ": ");
      wrefresh(if_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(if_contents[history_num][if_reg_num],val_buf);
    }

    if_reg_num++;
  }else if(strncmp(readbuffer,"g",1) == 0){
    // We are getting an IF/ID register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, if_id_reg_num, if_id_contents, if_id_reg_names);
      mvwaddstr(if_id_win,if_id_reg_num+1,1,if_id_reg_names[if_id_reg_num]);
      waddstr(if_id_win, ": ");
      wrefresh(if_id_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(if_id_contents[history_num][if_id_reg_num],val_buf);
    }

    if_id_reg_num++;
  }else if(strncmp(readbuffer,"d",1) == 0){
    // We are getting an ID register
    
    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, id_reg_num, id_contents, id_reg_names);
      mvwaddstr(id_win,id_reg_num+1,1,id_reg_names[id_reg_num]);
      waddstr(id_win, ": ");
      wrefresh(id_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(id_contents[history_num][id_reg_num],val_buf);
    }

    id_reg_num++;
  }else if(strncmp(readbuffer,"h",1) == 0){
    // We are getting an ID/EX register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, id_ex_reg_num, id_ex_contents, id_ex_reg_names);
      mvwaddstr(id_ex_win,id_ex_reg_num+1,1,id_ex_reg_names[id_ex_reg_num]);
      waddstr(id_ex_win, ": ");
      wrefresh(id_ex_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(id_ex_contents[history_num][id_ex_reg_num],val_buf);
    }

    id_ex_reg_num++;
  }else if(strncmp(readbuffer,"e",1) == 0){
    // We are getting an EX register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, ex_reg_num, ex_contents, ex_reg_names);
      mvwaddstr(ex_win,ex_reg_num+1,1,ex_reg_names[ex_reg_num]);
      waddstr(ex_win, ": ");
      wrefresh(ex_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(ex_contents[history_num][ex_reg_num],val_buf);
    }

    ex_reg_num++;
  }else if(strncmp(readbuffer,"i",1) == 0){
    // We are getting an EX/MEM register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, ex_mem_reg_num, ex_mem_contents, ex_mem_reg_names);
      mvwaddstr(ex_mem_win,ex_mem_reg_num+1,1,ex_mem_reg_names[ex_mem_reg_num]);
      waddstr(ex_mem_win, ": ");
      wrefresh(ex_mem_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(ex_mem_contents[history_num][ex_mem_reg_num],val_buf);
    }

    ex_mem_reg_num++;
  }else if(strncmp(readbuffer,"m",1) == 0){
    // We are getting a MEM register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, mem_reg_num, mem_contents, mem_reg_names);
      mvwaddstr(mem_win,mem_reg_num+1,1,mem_reg_names[mem_reg_num]);
      waddstr(mem_win, ": ");
      wrefresh(mem_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(mem_contents[history_num][mem_reg_num],val_buf);
    }

    mem_reg_num++;
  }else if(strncmp(readbuffer,"j",1) == 0){
    // We are getting an MEM/WB register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, mem_wb_reg_num, mem_wb_contents, mem_wb_reg_names);
      mvwaddstr(mem_wb_win,mem_wb_reg_num+1,1,mem_wb_reg_names[mem_wb_reg_num]);
      waddstr(mem_wb_win, ": ");
      wrefresh(mem_wb_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(mem_wb_contents[history_num][mem_wb_reg_num],val_buf);
    }

    mem_wb_reg_num++;
  }else if(strncmp(readbuffer,"w",1) == 0){
    // We are getting a WB register

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, wb_reg_num, wb_contents, wb_reg_names);
      mvwaddstr(wb_win,wb_reg_num+1,1,wb_reg_names[wb_reg_num]);
      waddstr(wb_win, ": ");
      wrefresh(wb_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(wb_contents[history_num][wb_reg_num],val_buf);
    }

    wb_reg_num++;
  }else if(strncmp(readbuffer,"1",1) == 0){
    // We are getting an T_table
    if (!setup_registers) {
      parse_register(readbuffer, rs_reg_num, rs_contents, rs_reg_names);
      mvwaddstr(rs_win,rs_reg_num+1,1,rs_reg_names[rs_reg_num]);
      waddstr(rs_win, ": ");
      wrefresh(rs_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rs_contents[history_num][rs_reg_num],val_buf);
    }
    rs_reg_num++;
  }else if(strncmp(readbuffer,"3",1) == 0){
    // We are getting an T1_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, rs_tr1_reg_num, rs_tr1_contents, rs_tr1_reg_names);
      mvwaddstr(rs_tr1_win,rs_tr1_reg_num+1,1,rs_tr1_reg_names[rs_tr1_reg_num]);
      waddstr(rs_tr1_win, ": ");
      wrefresh(rs_tr1_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rs_tr1_contents[history_num][rs_tr1_reg_num],val_buf);
    }
    rs_tr1_reg_num++;
  }else if(strncmp(readbuffer,"2",1) == 0){
    // We are getting an T1_table

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, rs_t1_reg_num, rs_t1_contents, rs_t1_reg_names);
      mvwaddstr(rs_t1_win,rs_t1_reg_num+1,1,rs_t1_reg_names[rs_t1_reg_num]);
      waddstr(rs_t1_win, ": ");
      wrefresh(rs_t1_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rs_t1_contents[history_num][rs_t1_reg_num],val_buf);
    }
    rs_t1_reg_num++;
  }else if(strncmp(readbuffer,"5",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, rs_tr2_reg_num, rs_tr2_contents, rs_tr2_reg_names);
      mvwaddstr(rs_tr2_win,rs_tr2_reg_num+1,1,rs_tr2_reg_names[rs_tr2_reg_num]);
      waddstr(rs_tr2_win, ": ");
      wrefresh(rs_tr2_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rs_tr2_contents[history_num][rs_tr2_reg_num],val_buf);
    }
    rs_tr2_reg_num++;
  }else if(strncmp(readbuffer,"4",1) == 0){
    // We are getting an T2_table

    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, rs_t2_reg_num, rs_t2_contents, rs_t2_reg_names);
      mvwaddstr(rs_t2_win,rs_t2_reg_num+1,1,rs_t2_reg_names[rs_t2_reg_num]);
      waddstr(rs_t2_win, ": ");
      wrefresh(rs_t2_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rs_t2_contents[history_num][rs_t2_reg_num],val_buf);
    }
    rs_t2_reg_num++;
  }else if(strncmp(readbuffer,"6",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, rs_bz_reg_num, rs_bz_contents, rs_bz_reg_names);
      mvwaddstr(rs_bz_win,rs_bz_reg_num+1,1,rs_bz_reg_names[rs_bz_reg_num]);
      waddstr(rs_bz_win, ": ");
      wrefresh(rs_bz_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rs_bz_contents[history_num][rs_bz_reg_num],val_buf);
    }
    rs_bz_reg_num++;
  } else if(strncmp(readbuffer,"7",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, rob_rd_reg_num, rob_rd_contents, rob_rd_reg_names);
      mvwaddstr(rob_rd_win,rob_rd_reg_num+1,1,rob_rd_reg_names[rob_rd_reg_num]);
      waddstr(rob_rd_win, ": ");
      wrefresh(rob_rd_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rob_rd_contents[history_num][rob_rd_reg_num],val_buf);
    }
    rob_rd_reg_num++;
  } else if(strncmp(readbuffer,"8",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, rob_tn_reg_num, rob_tn_contents, rob_tn_reg_names);
      mvwaddstr(rob_tn_win,rob_tn_reg_num+1,1,rob_tn_reg_names[rob_tn_reg_num]);
      waddstr(rob_tn_win, ": ");
      wrefresh(rob_tn_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rob_tn_contents[history_num][rob_tn_reg_num],val_buf);
    }
    rob_tn_reg_num++;
  } else if(strncmp(readbuffer,"9",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, rob_to_reg_num, rob_to_contents, rob_to_reg_names);
      mvwaddstr(rob_to_win,rob_to_reg_num+1,1,rob_to_reg_names[rob_to_reg_num]);
      waddstr(rob_to_win, ": ");
      wrefresh(rob_to_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rob_to_contents[history_num][rob_to_reg_num],val_buf);
    }
    rob_to_reg_num++;
  } else if(strncmp(readbuffer,"o",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, rob_st_reg_num, rob_st_contents, rob_st_reg_names);
      mvwaddstr(rob_st_win,rob_st_reg_num+1,1,rob_st_reg_names[rob_st_reg_num]);
      waddstr(rob_st_win, ": ");
      wrefresh(rob_st_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(rob_st_contents[history_num][rob_st_reg_num],val_buf);
    }
    rob_st_reg_num++;
  } else if(strncmp(readbuffer,"r",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, fr_reg_num, fr_contents, fr_reg_names);
      mvwaddstr(fr_win,fr_reg_num+1,1,fr_reg_names[fr_reg_num]);
      waddstr(fr_win, ": ");
      wrefresh(fr_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(fr_contents[history_num][fr_reg_num],val_buf);
    }
    fr_reg_num++;

  } else if(strncmp(readbuffer,";",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, map_reg_num, map_contents, map_reg_names);
      mvwaddstr(map_win,map_reg_num+1,1,map_reg_names[map_reg_num]);
      waddstr(map_win, ": ");
      wrefresh(map_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(map_contents[history_num][map_reg_num],val_buf);
    }
    map_reg_num++;

  } else if(strncmp(readbuffer,"[",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, map_rd_reg_num, map_rd_contents, map_rd_reg_names);
      mvwaddstr(map_rd_win,map_rd_reg_num+1,1,map_rd_reg_names[map_rd_reg_num]);
      waddstr(map_rd_win, ": ");
      wrefresh(map_rd_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(map_rd_contents[history_num][map_rd_reg_num],val_buf);
    }
    map_rd_reg_num++;

  } else if(strncmp(readbuffer,"]",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, sq_reg_num, sq_contents, sq_reg_names);
      mvwaddstr(sq_win,sq_reg_num+1,1,sq_reg_names[sq_reg_num]);
      waddstr(sq_win, ": ");
      wrefresh(sq_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(sq_contents[history_num][sq_reg_num],val_buf);
    }
    sq_reg_num++;

  } else if(strncmp(readbuffer,"}",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, sq_rd_reg_num, sq_rd_contents, sq_rd_reg_names);
      mvwaddstr(sq_rd_win,sq_rd_reg_num+1,1,sq_rd_reg_names[sq_rd_reg_num]);
      waddstr(sq_rd_win, ": ");
      wrefresh(sq_rd_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(sq_rd_contents[history_num][sq_rd_reg_num],val_buf);
    }
    sq_rd_reg_num++;

  } else if(strncmp(readbuffer,"{",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, lq_reg_num, lq_contents, lq_reg_names);
      mvwaddstr(lq_win,lq_reg_num+1,1,lq_reg_names[lq_reg_num]);
      waddstr(lq_win, ": ");
      wrefresh(lq_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(lq_contents[history_num][lq_reg_num],val_buf);
    }
    lq_reg_num++;

  } else if(strncmp(readbuffer,"+",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, lq_addr_reg_num, lq_addr_contents, lq_addr_reg_names);
      mvwaddstr(lq_addr_win,lq_addr_reg_num+1,1,lq_addr_reg_names[lq_addr_reg_num]);
      waddstr(lq_addr_win, ": ");
      wrefresh(lq_addr_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(lq_addr_contents[history_num][lq_addr_reg_num],val_buf);
    }
    lq_addr_reg_num++;

  } else if(strncmp(readbuffer,"!",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, lq_busy_reg_num, lq_busy_contents, lq_busy_reg_names);
      mvwaddstr(lq_busy_win,lq_busy_reg_num+1,1,lq_busy_reg_names[lq_busy_reg_num]);
      waddstr(lq_busy_win, ": ");
      wrefresh(lq_busy_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(lq_busy_contents[history_num][lq_busy_reg_num],val_buf);
    }
    lq_busy_reg_num++;


  } else if(strncmp(readbuffer,"@",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, lq_dcache_reg_num, lq_dcache_contents, lq_dcache_reg_names);
      mvwaddstr(lq_dcache_win,lq_dcache_reg_num+1,1,lq_dcache_reg_names[lq_dcache_reg_num]);
      waddstr(lq_dcache_win, ": ");
      wrefresh(lq_dcache_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(lq_dcache_contents[history_num][lq_dcache_reg_num],val_buf);
    }
    lq_dcache_reg_num++;

  } else if(strncmp(readbuffer,"#",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, dcache_reg_num, dcache_contents, dcache_reg_names);
      mvwaddstr(dcache_win,dcache_reg_num+1,1,dcache_reg_names[dcache_reg_num]);
      waddstr(dcache_win, ": ");
      wrefresh(dcache_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(dcache_contents[history_num][dcache_reg_num],val_buf);
    }
    dcache_reg_num++;

  } else if(strncmp(readbuffer,"$",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, dcache_con_reg_num, dcache_con_contents, dcache_con_reg_names);
      mvwaddstr(dcache_con_win,dcache_con_reg_num+1,1,dcache_con_reg_names[dcache_con_reg_num]);
      waddstr(dcache_con_win, ": ");
      wrefresh(dcache_con_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(dcache_con_contents[history_num][dcache_con_reg_num],val_buf);
    }
    dcache_con_reg_num++;

  } else if(strncmp(readbuffer,"&",1) == 0){
    // We are getting an T2_ready_table
    if (!setup_registers) {
      parse_register(readbuffer, icache_reg_num, icache_contents, icache_reg_names);
      mvwaddstr(icache_win,icache_reg_num+1,1,icache_reg_names[icache_reg_num]);
      waddstr(icache_win, ": ");
      wrefresh(icache_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(icache_contents[history_num][icache_reg_num],val_buf);
    }
    icache_reg_num++;


  } else if(strncmp(readbuffer,"v",1) == 0){

    //we are processing misc register/wire data
    // If this is the first time we've seen the register,
    // add name and data to arrays
    if (!setup_registers) {
      parse_register(readbuffer, misc_reg_num, misc_contents, misc_reg_names);
      mvwaddstr(misc_win,(misc_reg_num%5)+1,(misc_reg_num/5)*30+1,misc_reg_names[misc_reg_num]);
      waddstr(misc_win, ": ");
      wrefresh(misc_win);
    } else {
      sscanf(readbuffer,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
      strcpy(misc_contents[history_num][misc_reg_num],val_buf);
    }

    misc_reg_num++;
  }else if (strncmp(readbuffer,"break",4) == 0) {
    // If this is the first time through, indicate that we've setup all of
    // the register arrays.
    setup_registers = 1;

    //we've received our last data segment, now go process it
    byte_num = 0;
    if_reg_num = 0;
    if_id_reg_num = 0;
    id_reg_num = 0;
    id_ex_reg_num = 0;
    ex_reg_num = 0;
    ex_mem_reg_num = 0;
    mem_reg_num = 0;
    mem_wb_reg_num = 0;
    wb_reg_num = 0;
    rs_reg_num = 0;
    rs_tr1_reg_num = 0;
    rs_t1_reg_num = 0;
    rs_tr2_reg_num = 0;
    rs_t2_reg_num = 0;
    rs_bz_reg_num = 0;

    rob_rd_reg_num = 0;
    rob_tn_reg_num = 0;
    rob_to_reg_num = 0;
    rob_st_reg_num = 0;

    fr_reg_num = 0;
    map_reg_num = 0;
    map_rd_reg_num = 0;
    sq_reg_num = 0;
    sq_rd_reg_num = 0;
    lq_reg_num = 0;
    lq_addr_reg_num = 0;
    lq_busy_reg_num = 0;
    lq_dcache_reg_num = 0;
    dcache_reg_num = 0;
    dcache_con_reg_num = 0;
    icache_reg_num = 0;

    misc_reg_num = 0;

    //update the simulator time, this won't change with 'b's
    mvwaddstr(sim_time_win,1,1,timebuffer[history_num]);
    wrefresh(sim_time_win);

    //tell the parent application we're ready to move on
    return(1); 
  }
  return(0);
}

//this initializes a ncurses window and sets up the arrays for exchanging reg information
void initcurses(int if_regs, int if_id_regs, int id_regs, int id_ex_regs, int ex_regs,
                int ex_mem_regs, int mem_regs, int mem_wb_regs, int wb_regs,
                int misc_regs, int rs_regs, int rob_regs, int sq_regs, int lq_regs, int dcache_regs, int dcache_con_regs, int icache_regs){
  int nbytes;
  int ready_val;

  done_state = 0;
  echo_data = 1;
  num_misc_regs = misc_regs;
  num_if_regs = if_regs;
  num_if_id_regs = if_id_regs;
  num_id_regs = id_regs;
  num_id_ex_regs = id_ex_regs;
  num_ex_regs = ex_regs;
  num_ex_mem_regs = ex_mem_regs;
  num_mem_regs = mem_regs;
  num_mem_wb_regs = mem_wb_regs;
  num_wb_regs = wb_regs;

  num_rs_regs = rs_regs;
  num_rs_t1_regs = rs_regs;
  num_rs_tr1_regs = rs_regs;
  num_rs_t2_regs = rs_regs;
  num_rs_tr2_regs = rs_regs;
  num_rs_bz_regs = rs_regs;

  num_rob_rd_regs = rob_regs;
  num_rob_tn_regs = rob_regs;  
  num_rob_to_regs = rob_regs;
  num_rob_st_regs = rob_regs;

  num_fr_regs = rob_regs;

  num_map_regs = rob_regs;
  num_map_rd_regs = rob_regs;

  num_sq_regs = sq_regs;
  num_sq_rd_regs = sq_regs;

  num_lq_regs = lq_regs;
  num_lq_addr_regs = lq_regs;
  num_lq_busy_regs = lq_regs;
  num_lq_dcache_regs = lq_regs;
  num_dcache_regs = dcache_regs;
  num_dcache_con_regs = dcache_con_regs;
  num_icache_regs = icache_regs;

  pid_t childpid;
  pipe(readpipe);
  pipe(writepipe);
  stdout_save = dup(1);
  childpid = fork();
  if(childpid == 0){
    close(PARENT_WRITE);
    close(PARENT_READ);
    fp = fdopen(CHILD_READ, "r");
    fp2 = fopen("program.out","w");

    //allocate room on the heap for the reg data
    inst_contents     = (char**) malloc(NUM_HISTORY*sizeof(char*));
    arf_contents      = (char**) malloc(NUM_HISTORY*sizeof(char*));
    int i=0;
    if_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    if_id_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    id_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    id_ex_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    ex_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    ex_mem_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    mem_contents      = (char***) malloc(NUM_HISTORY*sizeof(char**));
    mem_wb_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    wb_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    misc_contents     = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rs_contents		  = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rs_t1_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rs_t2_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rs_tr1_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rs_tr2_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rs_bz_contents    = (char***) malloc(NUM_HISTORY*sizeof(char**));

    rob_to_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rob_tn_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rob_rd_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    rob_st_contents   = (char***) malloc(NUM_HISTORY*sizeof(char**));
    fr_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    map_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    map_rd_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    sq_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    sq_rd_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    lq_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    lq_addr_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    lq_busy_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    lq_dcache_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    dcache_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    dcache_con_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));
    icache_contents       = (char***) malloc(NUM_HISTORY*sizeof(char**));

    timebuffer        = (char**) malloc(NUM_HISTORY*sizeof(char*));
    cycles            = (char**) malloc(NUM_HISTORY*sizeof(char*));
    clocks            = (char*) malloc(NUM_HISTORY*sizeof(char));
    resets            = (char*) malloc(NUM_HISTORY*sizeof(char));

    // allocate room for the register names (what is displayed)
    if_reg_names      = (char**) malloc(num_if_regs*sizeof(char*));
    if_id_reg_names   = (char**) malloc(num_if_id_regs*sizeof(char*));
    id_reg_names      = (char**) malloc(num_id_regs*sizeof(char*));
    id_ex_reg_names   = (char**) malloc(num_id_ex_regs*sizeof(char*));
    ex_reg_names      = (char**) malloc(num_ex_regs*sizeof(char*));
    ex_mem_reg_names  = (char**) malloc(num_ex_mem_regs*sizeof(char*));
    mem_reg_names     = (char**) malloc(num_mem_regs*sizeof(char*));
    mem_wb_reg_names  = (char**) malloc(num_mem_wb_regs*sizeof(char*));
    wb_reg_names      = (char**) malloc(num_wb_regs*sizeof(char*));
    misc_reg_names    = (char**) malloc(num_misc_regs*sizeof(char*));
    rs_reg_names	  = (char**) malloc(num_rs_regs*sizeof(char*));
    rs_tr1_reg_names  = (char**) malloc(num_rs_tr1_regs*sizeof(char*));
    rs_tr2_reg_names  = (char**) malloc(num_rs_tr2_regs*sizeof(char*));
    rs_t1_reg_names  = (char**) malloc(num_rs_t1_regs*sizeof(char*));
    rs_t2_reg_names  = (char**) malloc(num_rs_t2_regs*sizeof(char*));
    rs_bz_reg_names  = (char**) malloc(num_rs_bz_regs*sizeof(char*));
    rob_rd_reg_names = (char**) malloc(num_rob_rd_regs*sizeof(char*));
    rob_tn_reg_names = (char**) malloc(num_rob_tn_regs*sizeof(char*));
    rob_to_reg_names = (char**) malloc(num_rob_to_regs*sizeof(char*));
    rob_st_reg_names = (char**) malloc(num_rob_st_regs*sizeof(char*));
    fr_reg_names     = (char**) malloc(num_fr_regs*sizeof(char*));
    map_reg_names     = (char**) malloc(num_map_regs*sizeof(char*));
    map_rd_reg_names     = (char**) malloc(num_map_rd_regs*sizeof(char*));
    sq_reg_names     = (char**) malloc(num_sq_regs*sizeof(char*));
    sq_rd_reg_names     = (char**) malloc(num_sq_rd_regs*sizeof(char*));
    lq_reg_names     = (char**) malloc(num_lq_regs*sizeof(char*));
    lq_addr_reg_names     = (char**) malloc(num_lq_addr_regs*sizeof(char*));
    lq_busy_reg_names     = (char**) malloc(num_lq_busy_regs*sizeof(char*));
    lq_dcache_reg_names     = (char**) malloc(num_lq_dcache_regs*sizeof(char*));
    dcache_reg_names     = (char**) malloc(num_dcache_regs*sizeof(char*));
    dcache_con_reg_names     = (char**) malloc(num_dcache_con_regs*sizeof(char*));
    icache_reg_names     = (char**) malloc(num_icache_regs*sizeof(char*));
    int j=0;
    for(;i<NUM_HISTORY;i++){
      timebuffer[i]       = (char*) malloc(8);
      cycles[i]           = (char*) malloc(7);
      inst_contents[i]    = (char*) malloc(2*NUM_STAGES*10);
      arf_contents[i]     = (char*) malloc(NUM_ARF*20);
      if_contents[i]      = (char**) malloc(num_if_regs*sizeof(char*));
      if_id_contents[i]   = (char**) malloc(num_if_id_regs*sizeof(char*));
      id_contents[i]      = (char**) malloc(num_id_regs*sizeof(char*));
      id_ex_contents[i]   = (char**) malloc(num_id_ex_regs*sizeof(char*));
      ex_contents[i]      = (char**) malloc(num_ex_regs*sizeof(char*));
      ex_mem_contents[i]  = (char**) malloc(num_ex_mem_regs*sizeof(char*));
      mem_contents[i]     = (char**) malloc(num_mem_regs*sizeof(char*));
      mem_wb_contents[i]  = (char**) malloc(num_mem_wb_regs*sizeof(char*));
      wb_contents[i]      = (char**) malloc(num_wb_regs*sizeof(char*));
      misc_contents[i]    = (char**) malloc(num_misc_regs*sizeof(char*));
      rs_contents[i]	  = (char**) malloc(num_rs_regs*sizeof(char*));
      rs_tr1_contents[i]  = (char**) malloc(num_rs_tr1_regs*sizeof(char*));
      rs_tr2_contents[i]  = (char**) malloc(num_rs_tr2_regs*sizeof(char*));
      rs_t1_contents[i]	  = (char**) malloc(num_rs_t1_regs*sizeof(char*));
      rs_t2_contents[i]	  = (char**) malloc(num_rs_t2_regs*sizeof(char*));
      rs_bz_contents[i]   = (char**) malloc(num_rs_bz_regs*sizeof(char*));

      rob_tn_contents[i]  = (char**) malloc(num_rob_tn_regs*sizeof(char*));
      rob_to_contents[i]  = (char**) malloc(num_rob_to_regs*sizeof(char*));
      rob_rd_contents[i]  = (char**) malloc(num_rob_rd_regs*sizeof(char*));
      rob_st_contents[i]  = (char**) malloc(num_rob_st_regs*sizeof(char*));
      fr_contents[i]      = (char**) malloc(num_fr_regs*sizeof(char*));
      map_contents[i]      = (char**) malloc(num_map_regs*sizeof(char*));
      map_rd_contents[i]      = (char**) malloc(num_map_rd_regs*sizeof(char*));
      sq_contents[i]      = (char**) malloc(num_sq_regs*sizeof(char*));
      sq_rd_contents[i]      = (char**) malloc(num_sq_rd_regs*sizeof(char*));
      lq_contents[i]      = (char**) malloc(num_lq_regs*sizeof(char*));
      lq_addr_contents[i]      = (char**) malloc(num_lq_addr_regs*sizeof(char*));
      lq_busy_contents[i]      = (char**) malloc(num_lq_busy_regs*sizeof(char*));
      lq_dcache_contents[i]      = (char**) malloc(num_lq_dcache_regs*sizeof(char*));
      dcache_contents[i]      = (char**) malloc(num_dcache_regs*sizeof(char*));
      dcache_con_contents[i]      = (char**) malloc(num_dcache_con_regs*sizeof(char*));
      icache_contents[i]      = (char**) malloc(num_icache_regs*sizeof(char*));
    }
    setup_gui(fp);

    // Main loop for retrieving data and taking commands from user
    char quit_flag = 0;
    char resp=0;
    char running=0;
    int mem_addr=0;
    char goto_flag = 0;
    char cycle_flag = 0;
    char done_received = 0;
    memset(readbuffer,'\0',sizeof(readbuffer));
    while(!quit_flag){
      if (!done_received) {
        fgets(readbuffer, sizeof(readbuffer), fp);
        ready_val = processinput();
      }
      if(strcmp(readbuffer,"DONE") == 0) {
        done_received = 1;
        done_time = history_num - 1;
      }
      if(ready_val == 1 || done_received == 1){
        if(echo_data == 0 && done_received == 1) {
          running = 0;
          timeout(-1);
          echo_data = 1;
          history_num--;
          history_num%=NUM_HISTORY;
        }
        if(echo_data != 0){
          parsedata(history_num);
        }
        history_num++;
        // keep track of whether time wrapped around yet
        if (history_num == NUM_HISTORY)
          time_wrapped = 1;
        history_num%=NUM_HISTORY;

        //we're done reading the reg values for this iteration
        if (done_received != 1) {
          write(CHILD_WRITE, "n", 1);
          write(CHILD_WRITE, &mem_addr, 2);
        }
        char continue_flag = 0;
        int hist_num_temp = (history_num-1)%NUM_HISTORY;
        if (history_num==0) hist_num_temp = NUM_HISTORY-1;
        char echo_data_tmp,continue_flag_tmp;

        while(continue_flag == 0){
          resp=getch();
          if(running == 1){
            continue_flag = 1;
          }
          if(running == 0 || resp == 'p'){ 
            if(resp == 'n' && hist_num_temp == (history_num-1)%NUM_HISTORY){
              if (!done_received)
                continue_flag = 1;
            }else if(resp == 'n'){
              //forward in time, but not up to present yet
              hist_num_temp++;
              hist_num_temp%=NUM_HISTORY;
              parsedata(hist_num_temp);
            }else if(resp == 'r'){
              echo_data = 0;
              running = 1;
              timeout(0);
              continue_flag = 1;
            }else if(resp == 'p'){
              echo_data = 1;
              timeout(-1);
              running = 0;
              parsedata(hist_num_temp);
            }else if(resp == 'q'){
              //quit
              continue_flag = 1;
              quit_flag = 1;
            }else if(resp == 'b'){
              //We're goin BACK IN TIME, woohoo!
              // Make sure not to wrap around to NUM_HISTORY-1 if we don't have valid
              // data there (time_wrapped set to 1 when we wrap around to history 0)
              if (hist_num_temp > 0) {
                hist_num_temp--;
                parsedata(hist_num_temp);
              } else if (time_wrapped == 1) {
                hist_num_temp = NUM_HISTORY-1;
                parsedata(hist_num_temp);
              }
            }else if(resp == 'g' || resp == 'c'){
              // See if user wants to jump to clock cycle instead of sim time
              cycle_flag = (resp == 'c');

              // go to specified simulation time (either in history or
              // forward in simulation time).
              stop_time = get_time();
              
              // see if we already have that time in history
              int tmp_time;
              int cur_time;
              int delta;
              if (cycle_flag)
                sscanf(cycles[hist_num_temp], "%u", &cur_time);
              else
                sscanf(timebuffer[hist_num_temp], "%u", &cur_time);
              delta = (stop_time > cur_time) ? 1 : -1;
              if ((hist_num_temp+delta)%NUM_HISTORY != history_num) {
                tmp_time=hist_num_temp;
                i= (hist_num_temp+delta >= 0) ? (hist_num_temp+delta)%NUM_HISTORY : NUM_HISTORY-1;
                while (i!=history_num) {
                  if (cycle_flag)
                    sscanf(cycles[i], "%u", &cur_time);
                  else
                    sscanf(timebuffer[i], "%u", &cur_time);
                  if ((delta == 1 && cur_time >= stop_time) ||
                      (delta == -1 && cur_time <= stop_time)) {
                    hist_num_temp = i;
                    parsedata(hist_num_temp);
                    stop_time = 0;
                    break;
                  }

                  if ((i+delta) >=0)
                    i = (i+delta)%NUM_HISTORY;
                  else {
                    if (time_wrapped == 1)
                      i = NUM_HISTORY - 1;
                    else {
                      parsedata(hist_num_temp);
                      stop_time = 0;
                      break;
                    }
                  }
                }
              }

              // If we looked backwards in history and didn't find stop_time
              // then give up
              if (i==history_num && (delta == -1 || done_received == 1))
                stop_time = 0;

              // Set flags so that we run forward in the simulation until
              // it either ends, or we hit the desired time
              if (stop_time > 0) {
                // grab current values
                echo_data = 0;
                running = 1;
                timeout(0);
                continue_flag = 1;
                goto_flag = 1;
              }
            }
          }
        }
        // if we're instructed to goto specific time, see if we're there
        int cur_time=0;
        if (goto_flag==1) {
          if (cycle_flag)
            sscanf(cycles[hist_num_temp], "%u", &cur_time);
          else
            sscanf(timebuffer[hist_num_temp], "%u", &cur_time);
          if ((cur_time >= stop_time) ||
              (strcmp(readbuffer,"DONE")==0) ) {
            goto_flag = 0;
            echo_data = 1;
            running = 0;
            timeout(-1);
            continue_flag = 0;
            //parsedata(hist_num_temp);
          }
        }
      }
    }
    refresh();
    delwin(title_win);
    endwin();
    fflush(stdout);
    if(resp == 'q'){
      fclose(fp2);
      write(CHILD_WRITE, "Z", 1);
      exit(0);
    }
    readbuffer[0] = 0;
    while(strncmp(readbuffer,"DONE",4) != 0){
      if(fgets(readbuffer, sizeof(readbuffer), fp) != NULL)
        fputs(readbuffer, fp2);
    }
    fclose(fp2);
    fflush(stdout);
    write(CHILD_WRITE, "Z", 1);
    printf("Child Done Execution\n");
    exit(0);
  } else {
    close(CHILD_READ);
    close(CHILD_WRITE);
    dup2(PARENT_WRITE, 1);
    close(PARENT_WRITE);
    
  }
}


// Function to make testbench block until debugger is ready to proceed
int waitforresponse(){
  static int mem_start = 0;
  char c=0;
  while(c!='n' && c!='Z') read(PARENT_READ,&c,1);
  if(c=='Z') exit(0);
  mem_start = read(PARENT_READ,&c,1);
  mem_start = mem_start << 8 + read(PARENT_READ,&c,1);
  return(mem_start);
}

void flushpipe(){
  char c=0;
  read(PARENT_READ, &c, 1);
}

// Function to return string representation of opcode given inst encoding
char *get_opcode_str(int inst, int valid_inst)
{
  int opcode, check;
  char *str;
  
  if (valid_inst == ((int)'x' - (int)'0'))
    str = "-";
  else if(!valid_inst)
    str = "-";
  else if(inst==NOOP_INST)
    str = "nop";
  else {
    opcode = (inst >> 26) & 0x0000003f;
    check = (inst>>5) & 0x0000007f;
    switch(opcode)
    {
      case 0x00: str = (inst == 0x555) ? "halt" : "call_pal"; break;
      case 0x08: str = "lda"; break;
      case 0x09: str = "ldah"; break;
      case 0x0a: str = "ldbu"; break;
      case 0x0b: str = "ldqu"; break;
      case 0x0c: str = "ldwu"; break;
      case 0x0d: str = "stw"; break;
      case 0x0e: str = "stb"; break;
      case 0x0f: str = "stqu"; break;
      case 0x10: // INTA_GRP
         switch(check)
         {
           case 0x00: str = "addl"; break;
           case 0x02: str = "s4addl"; break;
           case 0x09: str = "subl"; break;
           case 0x0b: str = "s4subl"; break;
           case 0x0f: str = "cmpbge"; break;
           case 0x12: str = "s8addl"; break;
           case 0x1b: str = "s8subl"; break;
           case 0x1d: str = "cmpult"; break;
           case 0x20: str = "addq"; break;
           case 0x22: str = "s4addq"; break;
           case 0x29: str = "subq"; break;
           case 0x2b: str = "s4subq"; break;
           case 0x2d: str = "cmpeq"; break;
           case 0x32: str = "s8addq"; break;
           case 0x3b: str = "s8subq"; break;
           case 0x3d: str = "cmpule"; break;
           case 0x40: str = "addlv"; break;
           case 0x49: str = "sublv"; break;
           case 0x4d: str = "cmplt"; break;
           case 0x60: str = "addqv"; break;
           case 0x69: str = "subqv"; break;
           case 0x6d: str = "cmple"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x11: // INTL_GRP
         switch(check)
         {
           case 0x00: str = "and"; break;
           case 0x08: str = "bic"; break;
           case 0x14: str = "cmovlbs"; break;
           case 0x16: str = "cmovlbc"; break;
           case 0x20: str = "bis"; break;
           case 0x24: str = "cmoveq"; break;
           case 0x26: str = "cmovne"; break;
           case 0x28: str = "ornot"; break;
           case 0x40: str = "xor"; break;
           case 0x44: str = "cmovlt"; break;
           case 0x46: str = "cmovge"; break;
           case 0x48: str = "eqv"; break;
           case 0x61: str = "amask"; break;
           case 0x64: str = "cmovle"; break;
           case 0x66: str = "cmovgt"; break;
           case 0x6c: str = "implver"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x12: // INTS_GRP
         switch(check)
         {
           case 0x02: str = "mskbl"; break;
           case 0x06: str = "extbl"; break;
           case 0x0b: str = "insbl"; break;
           case 0x12: str = "mskwl"; break;
           case 0x16: str = "extwl"; break;
           case 0x1b: str = "inswl"; break;
           case 0x22: str = "mskll"; break;
           case 0x26: str = "extll"; break;
           case 0x2b: str = "insll"; break;
           case 0x30: str = "zap"; break;
           case 0x31: str = "zapnot"; break;
           case 0x32: str = "mskql"; break;
           case 0x34: str = "srl"; break;
           case 0x36: str = "extql"; break;
           case 0x39: str = "sll"; break;
           case 0x3b: str = "insql"; break;
           case 0x3c: str = "sra"; break;
           case 0x52: str = "mskwh"; break;
           case 0x57: str = "inswh"; break;
           case 0x5a: str = "extwh"; break;
           case 0x62: str = "msklh"; break;
           case 0x67: str = "inslh"; break;
           case 0x6a: str = "extlh"; break;
           case 0x72: str = "mskqh"; break;
           case 0x77: str = "insqh"; break;
           case 0x7a: str = "extqh"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x13: // INTM_GRP
         switch(check)
         {
           case 0x00: str = "mull"; break;
           case 0x20: str = "mulq"; break;
           case 0x30: str = "umulh"; break;
           case 0x40: str = "mullv"; break;
           case 0x60: str = "mulqv"; break;
           default: str = "invalid"; break;
         }
         break;
      case 0x14: str = "itfp"; break; // unimplemented
      case 0x15: str = "fltv"; break; // unimplemented
      case 0x16: str = "flti"; break; // unimplemented
      case 0x17: str = "fltl"; break; // unimplemented
      case 0x1a: str = "jsr"; break;
      case 0x1c: str = "ftpi"; break;
      case 0x20: str = "ldf"; break;
      case 0x21: str = "ldg"; break;
      case 0x22: str = "lds"; break;
      case 0x23: str = "ldt"; break;
      case 0x24: str = "stf"; break;
      case 0x25: str = "stg"; break;
      case 0x26: str = "sts"; break;
      case 0x27: str = "stt"; break;
      case 0x28: str = "ldl"; break;
      case 0x29: str = "ldq"; break;
      case 0x2a: str = "ldll"; break;
      case 0x2b: str = "ldql"; break;
      case 0x2c: str = "stl"; break;
      case 0x2d: str = "stq"; break;
      case 0x2e: str = "stlc"; break;
      case 0x2f: str = "stqc"; break;
      case 0x30: str = "br"; break;
      case 0x31: str = "fbeq"; break;
      case 0x32: str = "fblt"; break;
      case 0x33: str = "fble"; break;
      case 0x34: str = "bsr"; break;
      case 0x35: str = "fbne"; break;
      case 0x36: str = "fbge"; break;
      case 0x37: str = "fbgt"; break;
      case 0x38: str = "blbc"; break;
      case 0x39: str = "beq"; break;
      case 0x3a: str = "blt"; break;
      case 0x3b: str = "ble"; break;
      case 0x3c: str = "blbs"; break;
      case 0x3d: str = "bne"; break;
      case 0x3e: str = "bge"; break;
      case 0x3f: str = "bgt"; break;
      default: str = "invalid"; break;
    }
  }

  return str;
}

// Function to parse register $display() from testbench and add to
// names/contents arrays
void parse_register(char *readbuf, int reg_num, char*** contents, char** reg_names) {
  char name_buf[32];
  char val_buf[32];
  int tmp_len;

  sscanf(readbuf,"%*c%s %d:%s",name_buf,&tmp_len,val_buf);
  int i=0;
  for (;i<NUM_HISTORY;i++){
    contents[i][reg_num] = (char*) malloc((tmp_len+1)*sizeof(char));
  }
  strcpy(contents[history_num][reg_num],val_buf);
  reg_names[reg_num] = (char*) malloc((strlen(name_buf)+1)*sizeof(char));
  strncpy(reg_names[reg_num], readbuf+1, strlen(name_buf));
  reg_names[reg_num][strlen(name_buf)] = '\0';
}

// Ask user for simulation time to stop at
// Since the enter key isn't detected, user must press 'g' key
//  when finished entering a number.
int get_time() {
  int col = COLS/2-6;
  wattron(title_win,A_REVERSE);
  mvwprintw(title_win,1,col,"goto time: ");
  wrefresh(title_win);
  int resp=0;
  int ptr = 0;
  char buf[32];
  int i;
  
  resp=wgetch(title_win);
  while(resp != 'g' && resp != KEY_ENTER && resp != ERR && ptr < 6) {
    if (isdigit((char)resp)) {
      waddch(title_win,(char)resp);
      wrefresh(title_win);
      buf[ptr++] = (char)resp;
    }
    resp=wgetch(title_win);
  }

  // Clean up title window
  wattroff(title_win,A_REVERSE);
  mvwprintw(title_win,1,col,"           ");
  for(i=0;i<ptr;i++)
    waddch(title_win,' ');

  wrefresh(title_win);

  buf[ptr] = '\0';
  return atoi(buf);
}
