
import pynq
import pynq.lib
from .constants import *
#from pynq.lib.logictools import TraceAnalyzer


__author__ = "Johannes Vanoverschelde"
__copyright__ = "Copyright 2017, Dekimo"
__email__ = "johannes.vanoverschelde@dekimo.com"


class BaseUZOverlay(pynq.Overlay):
    """ The Aquantis overlay for the Microzed


    Attributes
    ----------
    iop1 : IOP
         IO processor connected to the PMODA interface
    iop2 : IOP
         IO processor connected to the PMODB interface
    trace_pmoda : pynq.logictools.TraceAnalyzer
        Trace analyzer block on PMODA interface, controlled by PS.
    trace_pmodb : pynq.logictools.TraceAnalyzer
        Trace analyzer block on PMODB interface, controlled by PS. . 
    leds : AxiGPIO
         4-bit output GPIO for interacting with the green LEDs LD0-3
    buttons : AxiGPIO
         2-bit input GPIO for interacting with the buttons BTN0-3
    """

    def __init__(self, bitfile, **kwargs):
        super().__init__(bitfile, **kwargs)
        if self.is_loaded():
            #self.iop1.mbtype = "Pmod"
            #self.iop2.mbtype = "Pmod"
            
            #self.PMODA = self.iop1.mb_info
            #self.PMODB = self.iop2.mb_info
            
            self.leds = self.axi_gpio_0_led.channel1
            self.buttons = self.axi_gpio_0_button.channel1
            self.leds.setlength(4)
            self.buttons.setlength(2)
            self.leds.setdirection("out")
            self.buttons.setdirection("in")
            
            #self.trace_pmoda = TraceAnalyzer(
            #    self.trace_analyzer_pmoda.description['ip'],
            #    PYNQZ1_PMODA_SPECIFICATION)
            #self.trace_pmodb = TraceAnalyzer(
            #    self.trace_analyzer_pmodb.description['ip'],
            #    PYNQZ1_PMODB_SPECIFICATION)
            
