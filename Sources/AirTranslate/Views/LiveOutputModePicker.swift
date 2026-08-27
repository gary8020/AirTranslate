import SwiftUI

struct LiveOutputModePicker: View {
    @Binding var selection: LiveOutputMode
    let isDisabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(AppText.outputMode)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Picker(AppText.outputMode, selection: selectionBinding) {
                ForEach(LiveOutputMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .allowsHitTesting(!isDisabled)
            .accessibilityRespondsToUserInteraction(!isDisabled)
            .opacity(isDisabled ? 0.6 : 1)
            .accessibilityLabel(AppText.outputMode)
            .accessibilityHint(isDisabled ? lockedAccessibilityHint : AppText.outputMode)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
    }

    private var lockedAccessibilityHint: String {
        AppText.localized(
            english: "Stop capture before changing the output mode.",
            korean: "출력 모드를 바꾸려면 먼저 캡처를 중지하세요.",
            japanese: "出力モードを変更するには、先にキャプチャを停止してください。",
            chineseSimplified: "请先停止采集，再更改输出模式。"
        )
    }

    private var selectionBinding: Binding<LiveOutputMode> {
        Binding(
            get: { selection },
            set: { mode in
                guard !isDisabled else { return }
                selection = mode
            }
        )
    }
}
