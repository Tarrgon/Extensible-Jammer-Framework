#ifdef DEBUG_ENABLED_FULL
allowFunctionsRecompile = 1;
allowFunctionsLog = 1;
#endif

class CfgFunctions {
	class EJF {
		class Common {
			file = QPATHTOFOLDER(functions\common);

			class addJammer {};
			class checkUavConnectability {};
			class enteredDetectionRange {};
			class enteredInnerRange {};
			class enteredOuterRange {};
			class exitedDetectionRange {};
			class exitedInnerRange {};
			class exitedOuterRange {};
			class getEnabledJammers {};
			class getJammerData {};
			class getJammerHashMap {};
			class getJammerOwner {};
			class getJammerPosition {};
			class getJammerSide {};
			class getJammingLogic {};
			class getSavedWaypointsHashMap {};
			class jammerCanTargetDrone {};
			class removeJammedDrones {};
			class removeJammer {};
			class setJammerEnabled {};
			class setJammerLogic {};
			class setJammerOwner {};
			class setJammerRanges {};
			class setJammerSide {};

			class settings {
				preInit = 1;
			};
		}

		class Client {
			file = QPATHTOFOLDER(functions\client);

			class checkNearbyJammers {};
			class disabledUavsUpdated {};
			class disconnectFromUav {};
			class initClient {};
			class iOwnJammer {};
			class setFilmGrainIntensity {};
		}

		class Server {
			file = QPATHTOFOLDER(functions\server);

			class aiLoop {};
			class anyEnemyUavsInInnerRange {};
			class disconnectAllUavsInRange {};
			class enableAllUavsInRange {};
			class generateId {};
			class initServer {};
			class initServerEventHandlers {};
			class main {};
			class processJamming {};
			class setHasCustomAction {};
			class unjamAll {};

			class startInit {
				preInit = 1;
			};
		}
	};
};