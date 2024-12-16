import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 乐观状态
 */
class SubscribeButton extends StatefulWidget {
  //构造方法
  const SubscribeButton({
    super.key,
    required this.viewModel,
  });

  /// Subscribe button view model.
  final SubscribeButtonViewModel viewModel;

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  /// Listen to ViewModel changes.
  void _onViewModelChange() {
    // If the subscription action has failed
    if (widget.viewModel.error) {
      // Reset the error state
      widget.viewModel.error = false;
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to subscribe'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return FilledButton(
          onPressed: widget.viewModel.subscribe,
          style: widget.viewModel.subscribed
              ? SubscribeButtonStyle.subscribed
              : SubscribeButtonStyle.unsubscribed,
          child: widget.viewModel.subscribed
              ? const Text('Subscribed')
              : const Text('Subscribe'),
        );
      },
    );
  }
}

class SubscribeButtonViewModel extends ChangeNotifier {
  // Whether the user is subscribed
  bool subscribed = false;

// Whether the subscription action has failed
  bool error = false;

  SubscribeButtonViewModel({
    required this.subscriptionRepository,
  });

  // Subscription action
  Future<void> subscribe() async {
    // Ignore taps when subscribed
    if (subscribed) {
      return;
    }

    // Optimistic state.
    // It will be reverted if the subscription fails.
    subscribed = true;
    // Notify listeners to update the UI
    notifyListeners();

    try {
      await subscriptionRepository.subscribe();
    } catch (e) {
      print('Failed to subscribe: $e');
      // Revert to the previous state
      subscribed = false;
      // Set the error state
      error = true;
    } finally {
      notifyListeners();
    }
  }

  final SubscriptionRepository subscriptionRepository;
}

class SubscriptionRepository {
  /// Simulates a network request and then fails.
  Future<void> subscribe() async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));
    // Fail after one second
    throw Exception('Failed to subscribe');
  }
}

class SubscribeButtonStyle {
  static const unsubscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.red),
  );

  static const subscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.green),
  );
}
